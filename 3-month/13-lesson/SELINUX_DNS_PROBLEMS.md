# Задание 2: SELinux: проблема с удаленным обновлением зоны DNS

Обеспечить работоспособность приложения при включенном selinux.

- Развернуть приложенный стенд
<https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems>
- Выяснить причину неработоспособности механизма обновления зоны (см. README);
- Предложить решение (или решения) для данной проблемы;
- Выбрать одно из решений для реализации, предварительно обосновав выбор;
- Реализовать выбранное решение и продемонстрировать его работоспособность.
- README с анализом причины неработоспособности, возможными способами решения и обоснованием выбора одного из них;
- Исправленный стенд или демонстрация работоспособной системы скриншотами и описанием.

## Тестовое окружение

1. Копируем [test environment](https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems) в `./selinux_dns_problems`
2. Запускаем окружение  

   ```shell
   cd ./selinux_dns_problems
   vagrant up
   ```

3. List hosts

   ```shell
   vagrant status
   ```

   ```log
   Current machine states:
   ns01                      running (virtualbox)
   client                    running (virtualbox)
   ```

## Убедитесь, что проблема существует

Проверяем зону:

```shell
dig @192.168.50.10 ns01.dns.lab
```

```log
; <<>> DiG 9.11.4-P2-RedHat-9.11.4-16.P2.el7_8.6 <<>> @192.168.50.10 ns01.dns.lab
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 6196
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;ns01.dns.lab.                  IN      A

;; ANSWER SECTION:
ns01.dns.lab.           3600    IN      A       192.168.50.10

;; AUTHORITY SECTION:
dns.lab.                3600    IN      NS      ns01.dns.lab.

;; Query time: 3 msec
;; SERVER: 192.168.50.10#53(192.168.50.10)
;; WHEN: Thu Apr 08 20:02:40 UTC 2021
;; MSG SIZE  rcvd: 71
```

---

Попробуем обновить зону:

```shell
nsupdate -k /etc/named.zonetransfer.key
> server 192.168.50.10
> zone ddns.lab
> update add www.ddns.lab. 60 A 192.168.50.15
> send
```

```log
update failed: SERVFAIL
```

---

Добавляем плей в [test.yml](./selinux_dns_problems/provisioning/test.yml) to provision

```yaml
- name: Run tests
  import_playbook: test.yml
```

---

Повторяем:

```shell
vagrant provision
```

```log
...
PLAY [Test nsupdate from client] ***********************************************

TASK [Gathering Facts] *********************************************************
ok: [client]

TASK [Run nsupdate] ************************************************************
changed: [client]

TASK [Check output] ************************************************************
ok: [client] => {
    "nsupdate": {
        "changed": true,
        "cmd": "cat <<EOF | nsupdate -k /etc/named.zonetransfer.key\nserver 192.168.50.10\nzone ddns.lab\nupdate add www.ddns.lab. 60 A 192.168.50.15\nsend\n",
        "delta": "0:00:00.019634",
        "end": "2021-04-08 22:56:20.303103",
        "failed": false,
        "failed_when_result": false,
        "msg": "non-zero return code",
        "rc": 2,
        "start": "2021-04-08 22:56:20.283469",
        "stderr": "/bin/sh: line 4: warning: here-document at line 0 delimited by end-of-file (wanted `EOF')\nupdate failed: SERVFAIL",
        "stderr_lines": [
            "/bin/sh: line 4: warning: here-document at line 0 delimited by end-of-file (wanted `EOF')",
            "update failed: SERVFAIL"
        ],
        "stdout": "",
        "stdout_lines": []
    }
}

PLAY RECAP *********************************************************************
client                     : ok=10   changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Ошибка:

```log
update failed: SERVFAIL
```

## Анализ

Установим режим SELinux на `permissive` и повторим `nsupdate`:

Хост `ns01`

```shell
[root@ns01 vagrant]# setenforce 0
[root@ns01 vagrant]# getenforce 
Permissive
```

На хосте:

```shell
vagrant provision
```

```log
...

TASK [Run nsupdate] ************************************************************
changed: [client]

TASK [Check output] ************************************************************
ok: [client] => {
    "nsupdate": {
        "changed": true,
        "cmd": "cat <<EOF | nsupdate -k /etc/named.zonetransfer.key\nserver 192.168.50.10\nzone ddns.lab\nupdate add www.ddns.lab. 60 A 192.168.50.15\nsend\nEOF\n",
        "delta": "0:00:00.025792",
        "end": "2021-04-08 23:03:20.353296",
        "failed": false,
        "failed_when_result": false,
        "rc": 0,
        "start": "2021-04-08 23:03:20.327504",
        "stderr": "",
        "stderr_lines": [],
        "stdout": "",
        "stdout_lines": []
    }
}

PLAY RECAP *********************************************************************
client                     : ok=10   changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Нет ошибок

---

Запускаем `sealert` на `ns01`:

```shell
LANG=C sealert -a /var/log/audit/audit.log
```

```shell
100% done
found 3 alerts in /var/log/audit/audit.log
--------------------------------------------------------------------------------

SELinux is preventing /usr/sbin/named from search access on the directory net.

*****  Plugin catchall (100. confidence) suggests   **************************

If you believe that named should be allowed search access on the net directory by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0000
# semodule -i my-iscworker0000.pp


Additional Information:
Source Context                system_u:system_r:named_t:s0
Target Context                system_u:object_r:sysctl_net_t:s0
Target Objects                net [ dir ]
Source                        isc-worker0000
Source Path                   /usr/sbin/named
Port                          <Unknown>
Host                          <Unknown>
Source RPM Packages           bind-9.11.4-16.P2.el7_8.6.x86_64
Target RPM Packages           
Policy RPM                    selinux-policy-3.13.1-229.el7_6.12.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Permissive
Host Name                     ns01
Platform                      Linux ns01 3.10.0-957.12.2.el7.x86_64 #1 SMP Tue
                              May 14 21:24:32 UTC 2019 x86_64 x86_64
Alert Count                   7
First Seen                    2021-04-08 22:29:55 UTC
Last Seen                     2021-04-08 23:03:13 UTC
Local ID                      f19f14e8-8306-4c1c-ae94-ed6ba5c46184

Raw Audit Messages
type=AVC msg=audit(1597878193.955:6584): avc:  denied  { search } for  pid=16569 comm="isc-worker0000" name="net" dev="proc" ino=33588 scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:sysctl_net_t:s0 tclass=dir permissive=1


type=AVC msg=audit(1597878193.955:6584): avc:  denied  { read } for  pid=16569 comm="isc-worker0000" name="ip_local_port_range" dev="proc" ino=75599 scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:sysctl_net_t:s0 tclass=file permissive=1


type=AVC msg=audit(1597878193.955:6584): avc:  denied  { open } for  pid=16569 comm="isc-worker0000" path="/proc/sys/net/ipv4/ip_local_port_range" dev="proc" ino=75599 scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:sysctl_net_t:s0 tclass=file permissive=1


type=SYSCALL msg=audit(1597878193.955:6584): arch=x86_64 syscall=open success=yes exit=EAGAIN a0=7fae5c22c760 a1=0 a2=1b6 a3=24 items=0 ppid=16567 pid=16569 auid=4294967295 uid=25 gid=25 euid=25 suid=25 fsuid=25 egid=25 sgid=25 fsgid=25 tty=(none) ses=4294967295 comm=isc-worker0000 exe=/usr/sbin/named subj=system_u:system_r:named_t:s0 key=(null)

Hash: isc-worker0000,named_t,sysctl_net_t,dir,search

--------------------------------------------------------------------------------

SELinux is preventing /usr/sbin/named from create access on the file named.ddns.lab.view1.jnl.

*****  Plugin catchall_labels (83.8 confidence) suggests   *******************

If you want to allow named to have create access on the named.ddns.lab.view1.jnl file
Then you need to change the label on named.ddns.lab.view1.jnl
Do
# semanage fcontext -a -t FILE_TYPE 'named.ddns.lab.view1.jnl'
where FILE_TYPE is one of the following: dnssec_trigger_var_run_t, ipa_var_lib_t, krb5_host_rcache_t, krb5_keytab_t, named_cache_t, named_log_t, named_tmp_t, named_var_run_t, named_zone_t.
Then execute:
restorecon -v 'named.ddns.lab.view1.jnl'


*****  Plugin catchall (17.1 confidence) suggests   **************************

If you believe that named should be allowed create access on the named.ddns.lab.view1.jnl file by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0000
# semodule -i my-iscworker0000.pp


Additional Information:
Source Context                system_u:system_r:named_t:s0
Target Context                system_u:object_r:etc_t:s0
Target Objects                named.ddns.lab.view1.jnl [ file ]
Source                        isc-worker0000
Source Path                   /usr/sbin/named
Port                          <Unknown>
Host                          <Unknown>
Source RPM Packages           bind-9.11.4-16.P2.el7_8.6.x86_64
Target RPM Packages           
Policy RPM                    selinux-policy-3.13.1-229.el7_6.12.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Permissive
Host Name                     ns01
Platform                      Linux ns01 3.10.0-957.12.2.el7.x86_64 #1 SMP Tue
                              May 14 21:24:32 UTC 2019 x86_64 x86_64
Alert Count                   4
First Seen                    2021-04-08 22:51:02 UTC
Last Seen                     2021-04-08 23:03:20 UTC
Local ID                      a1a92fab-0259-48e9-96ec-7c0113ffd637

Raw Audit Messages
type=AVC msg=audit(1597878200.349:6596): avc:  denied  { create } for  pid=16569 comm="isc-worker0000" name="named.ddns.lab.view1.jnl" scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:etc_t:s0 tclass=file permissive=1


type=AVC msg=audit(1597878200.349:6596): avc:  denied  { write } for  pid=16569 comm="isc-worker0000" path="/etc/named/dynamic/named.ddns.lab.view1.jnl" dev="sda1" ino=301 scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:etc_t:s0 tclass=file permissive=1


type=SYSCALL msg=audit(1597878200.349:6596): arch=x86_64 syscall=open success=yes exit=ENXIO a0=7fae5da77050 a1=241 a2=1b6 a3=24 items=0 ppid=1 pid=16569 auid=4294967295 uid=25 gid=25 euid=25 suid=25 fsuid=25 egid=25 sgid=25 fsgid=25 tty=(none) ses=4294967295 comm=isc-worker0000 exe=/usr/sbin/named subj=system_u:system_r:named_t:s0 key=(null)

Hash: isc-worker0000,named_t,etc_t,file,create

--------------------------------------------------------------------------------

SELinux is preventing /usr/sbin/named from getattr access on the file /proc/sys/net/ipv4/ip_local_port_range.

*****  Plugin catchall (100. confidence) suggests   **************************

If you believe that named should be allowed getattr access on the ip_local_port_range file by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0000
# semodule -i my-iscworker0000.pp


Additional Information:
Source Context                system_u:system_r:named_t:s0
Target Context                system_u:object_r:sysctl_net_t:s0
Target Objects                /proc/sys/net/ipv4/ip_local_port_range [ file ]
Source                        isc-worker0000
Source Path                   /usr/sbin/named
Port                          <Unknown>
Host                          <Unknown>
Source RPM Packages           bind-9.11.4-16.P2.el7_8.6.x86_64
Target RPM Packages           
Policy RPM                    selinux-policy-3.13.1-229.el7_6.12.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Permissive
Host Name                     ns01
Platform                      Linux ns01 3.10.0-957.12.2.el7.x86_64 #1 SMP Tue
                              May 14 21:24:32 UTC 2019 x86_64 x86_64
Alert Count                   1
First Seen                    2021-04-08 23:03:13 UTC
Last Seen                     2021-04-08 23:03:13 UTC
Local ID                      f377bbdc-8edf-4219-85f9-ac416ff7685c

Raw Audit Messages
type=AVC msg=audit(1597878193.955:6585): avc:  denied  { getattr } for  pid=16569 comm="isc-worker0000" path="/proc/sys/net/ipv4/ip_local_port_range" dev="proc" ino=75599 scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:sysctl_net_t:s0 tclass=file permissive=1


type=SYSCALL msg=audit(1597878193.955:6585): arch=x86_64 syscall=fstat success=yes exit=0 a0=b a1=7fae597c8240 a2=7fae597c8240 a3=7fae597c81a0 items=0 ppid=16567 pid=16569 auid=4294967295 uid=25 gid=25 euid=25 suid=25 fsuid=25 egid=25 sgid=25 fsgid=25 tty=(none) ses=4294967295 comm=isc-worker0000 exe=/usr/sbin/named subj=system_u:system_r:named_t:s0 key=(null)

Hash: isc-worker0000,named_t,sysctl_net_t,file,getattr
```

Есть 3 проблемы:

1. SELinux запрещает /usr/sbin/named от доступа к поиску в каталоге net.  
2. SELinux не позволяет /usr/sbin/named создавать доступ к файлу с именем .ddns.lab.view1.jnl.  
3. SELinux запрещает /usr/sbin/named доступа getattr к файлу /proc/sys/net/ipv4/ip_local_port_range.

## Пути решения проблемы

Иеются предупреждения о доступе к `/proc/sys/net`.

Поэтому сначала решим проблему с помощью создания доступа к файлу динамической зоны `/etc/named/dynamic/named.ddns.lab.view1.jnl`.

## Создаём доступ к файлу с именем .ddns.lab.view1.jnl

`sealert` рекомендует изменить контекст файла зоны или создать политику selinux. Но создание политики selinux - так себе идея. Политика Selinux может допускать слишком много разрешений, фактически больше, чем необходимо процессу, поэтому наш сервис может быть скомпрометирован.

Необходимо осмотреть, что `sealert` рекомендует при изменении контекста файла зоны.

Дать разрешение named на создание файла named.ddns.lab.view1.jnl.  
Затем необходимо изменить метку на named.ddns.lab.view1.jnl.  
Выполнить
`semanage fcontext -a -t FILE_TYPE 'named.ddns.lab.view1.jnl'`  
где FILE_TYPE является одним из следующих: `dnssec_trigger_var_run_t`,`ipa_var_lib_t`, `krb5_host_rcache_t`,`krb5_keytab_t`, `named_cache_t`,`named_log_t`, `named_z`,`name_t`.  
Затем выполняем:  
`restorecon -v 'named.ddns.lab.view1.jnl'`

Но named.ddns.lab.view1.jnl - это имя динамической зоны. Итак, нам нужно обновить тип файла родительского каталога `/etc/named/dynamic`.

Получаем текущий fcontext

```shell
ls -laZ /etc/named/dynamic/
```

```log
drw-rwx---. root  named unconfined_u:object_r:etc_t:s0   .
drw-rwx---. root  named system_u:object_r:etc_t:s0       ..
-rw-rw----. named named system_u:object_r:etc_t:s0       named.ddns.lab
-rw-rw----. named named system_u:object_r:etc_t:s0       named.ddns.lab.view1
```

Это `Unlimited_u: object_r: etc_t: s0`. Но домен `named_zone_t` выглядит более предпочтительным. Итак, нам нужно выполнить:

```shell
semanage fcontext -a -t named_zone_t '/etc/named/dynamic'
restorecon -v '/etc/named/dynamic'
```

Давайте добавим это в плейбук `./selinux_dns_problems/provisioning/selinux.yml`:

```yaml
- name: Allow named to manipulate dynamic zone files
  sefcontext:
    target: '/etc/named/dynamic'
    setype: named_zone_t
    state: present
  register: setfcontext

- name: Apply new SELinux file context to /etc/named/dynamic
  command: restorecon -irv /etc/named/dynamic
  register: restorecon
  when: setfcontext.changed

- debug:
    var: restorecon
  when: restorecon is defined
```

Провижиним vagrant инстанс `ns01` и смотрим результат:

```shell
ls -laZ /etc/named/dynamic
```

```log
drw-rwx---. root  named unconfined_u:object_r:named_zone_t:s0 .
drw-rwx---. root  named system_u:object_r:etc_t:s0       ..
-rw-rw----. named named system_u:object_r:etc_t:s0       named.ddns.lab
-rw-rw----. named named system_u:object_r:etc_t:s0       named.ddns.lab.view1
-rw-r--r--. named named system_u:object_r:named_zone_t:s0 named.ddns.lab.view1.jnl
```

Контекст теперь правильный: `unconfined_u:object_r:named_zone_t:s0`.

Зона обновлена успешно:

```log
PLAY [Test nsupdate from client] ***********************************************

TASK [Gathering Facts] *********************************************************
ok: [client]

TASK [Run nsupdate] ************************************************************
changed: [client]

TASK [Check output] ************************************************************
ok: [client] => {
    "nsupdate": {
        "changed": true,
        "cmd": "cat <<EOF | nsupdate -k /etc/named.zonetransfer.key\nserver 192.168.50.10\nzone ddns.lab\nupdate add www.ddns.lab. 60 A 192.168.50.15\nsend\nEOF\n",
        "delta": "0:00:00.030660",
        "end": "2021-04-08 18:07:55.746234",
        "failed": false,
        "failed_when_result": false,
        "rc": 0,
        "start": "2021-04-08 18:07:55.715574",
        "stderr": "",
        "stderr_lines": [],
        "stdout": "",
        "stdout_lines": []
    }
}
```

Ensure ns01 can resolve www.ddns.lab. Run on `client`:

```shell
dig www.ddns.lab. @192.168.50.10
```

```log
; <<>> DiG 9.11.4-P2-RedHat-9.11.4-16.P2.el7_8.6 <<>> www.ddns.lab. @192.168.50.10
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 40949
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.ddns.lab.                  IN      A

;; ANSWER SECTION:
www.ddns.lab.           60      IN      A       192.168.50.15

;; AUTHORITY SECTION:
ddns.lab.               3600    IN      NS      ns01.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.           3600    IN      A       192.168.50.10

;; Query time: 0 msec
;; SERVER: 192.168.50.10#53(192.168.50.10)
;; WHEN: Thu Apr 08 22:12:40 UTC 2021
;; MSG SIZE  rcvd: 96
```

Всё работате!

## Ещё один способ

Мне кажется, что этот способ более правильный.

Посмотрим, что говорит `sudo semanage fcontext -l | grep named` on `ns01`:

```shell
sudo semanage fcontext -l | grep named
```

```log
/etc/rndc.*                                        regular file       system_u:object_r:named_conf_t:s0 
/var/named(/.*)?                                   all files          system_u:object_r:named_zone_t:s0 
/etc/unbound(/.*)?                                 all files          system_u:object_r:named_conf_t:s0 
/var/run/bind(/.*)?                                all files          system_u:object_r:named_var_run_t:s0 
/var/log/named.*                                   regular file       system_u:object_r:named_log_t:s0 
/var/run/named(/.*)?                               all files          system_u:object_r:named_var_run_t:s0 
/var/named/data(/.*)?                              all files          system_u:object_r:named_cache_t:s0 
/dev/xen/tapctrl.*                                 named pipe         system_u:object_r:xenctl_t:s0 
/var/run/unbound(/.*)?                             all files          system_u:object_r:named_var_run_t:s0 
/var/lib/softhsm(/.*)?                             all files          system_u:object_r:named_cache_t:s0 
/var/lib/unbound(/.*)?                             all files          system_u:object_r:named_cache_t:s0 
/var/named/slaves(/.*)?                            all files          system_u:object_r:named_cache_t:s0 
/var/named/chroot(/.*)?                            all files          system_u:object_r:named_conf_t:s0 
/etc/named\.rfc1912.zones                          regular file       system_u:object_r:named_conf_t:s0 
/var/named/dynamic(/.*)?                           all files          system_u:object_r:named_cache_t:s0 
/var/named/chroot/etc(/.*)?                        all files          system_u:object_r:etc_t:s0 
/var/named/chroot/lib(/.*)?                        all files          system_u:object_r:lib_t:s0 
/var/named/chroot/proc(/.*)?                       all files          <<None>>
/var/named/chroot/var/tmp(/.*)?                    all files          system_u:object_r:named_cache_t:s0 
/var/named/chroot/usr/lib(/.*)?                    all files          system_u:object_r:lib_t:s0 
/var/named/chroot/etc/pki(/.*)?                    all files          system_u:object_r:cert_t:s0 
/var/named/chroot/run/named.*                      all files          system_u:object_r:named_var_run_t:s0 
/var/named/chroot/var/named(/.*)?                  all files          system_u:object_r:named_zone_t:s0 
/usr/lib/systemd/system/named.*                    regular file       system_u:object_r:named_unit_file_t:s0 
/var/named/chroot/var/run/dbus(/.*)?               all files          system_u:object_r:system_dbusd_var_run_t:s0 
/usr/lib/systemd/system/unbound.*                  regular file       system_u:object_r:named_unit_file_t:s0 
/var/named/chroot/var/log/named.*                  regular file       system_u:object_r:named_log_t:s0 
/var/named/chroot/var/run/named.*                  all files          system_u:object_r:named_var_run_t:s0 
/var/named/chroot/var/named/data(/.*)?             all files          system_u:object_r:named_cache_t:s0 
/usr/lib/systemd/system/named-sdb.*                regular file       system_u:object_r:named_unit_file_t:s0 
/var/named/chroot/var/named/slaves(/.*)?           all files          system_u:object_r:named_cache_t:s0 
/var/named/chroot/etc/named\.rfc1912.zones         regular file       system_u:object_r:named_conf_t:s0 
/var/named/chroot/var/named/dynamic(/.*)?          all files          system_u:object_r:named_cache_t:s0 
/var/run/ndc                                       socket             system_u:object_r:named_var_run_t:s0 
/dev/gpmdata                                       named pipe         system_u:object_r:gpmctl_t:s0 
/dev/initctl                                       named pipe         system_u:object_r:initctl_t:s0 
/dev/xconsole                                      named pipe         system_u:object_r:xconsole_device_t:s0 
/usr/sbin/named                                    regular file       system_u:object_r:named_exec_t:s0 
/etc/named\.conf                                   regular file       system_u:object_r:named_conf_t:s0 
/usr/sbin/lwresd                                   regular file       system_u:object_r:named_exec_t:s0 
/var/run/initctl                                   named pipe         system_u:object_r:initctl_t:s0 
/usr/sbin/unbound                                  regular file       system_u:object_r:named_exec_t:s0 
/usr/sbin/named-sdb                                regular file       system_u:object_r:named_exec_t:s0 
/var/named/named\.ca                               regular file       system_u:object_r:named_conf_t:s0 
/etc/named\.root\.hints                            regular file       system_u:object_r:named_conf_t:s0 
/var/named/chroot/dev                              directory          system_u:object_r:device_t:s0 
/etc/rc\.d/init\.d/named                           regular file       system_u:object_r:named_initrc_exec_t:s0 
/usr/sbin/named-pkcs11                             regular file       system_u:object_r:named_exec_t:s0 
/etc/rc\.d/init\.d/unbound                         regular file       system_u:object_r:named_initrc_exec_t:s0 
/usr/sbin/unbound-anchor                           regular file       system_u:object_r:named_exec_t:s0 
/usr/sbin/named-checkconf                          regular file       system_u:object_r:named_checkconf_exec_t:s0 
/usr/sbin/unbound-control                          regular file       system_u:object_r:named_exec_t:s0 
/var/named/chroot_sdb/dev                          directory          system_u:object_r:device_t:s0 
/var/named/chroot/var/log                          directory          system_u:object_r:var_log_t:s0 
/var/named/chroot/dev/log                          socket             system_u:object_r:devlog_t:s0 
/etc/rc\.d/init\.d/named-sdb                       regular file       system_u:object_r:named_initrc_exec_t:s0 
/var/named/chroot/dev/null                         character device   system_u:object_r:null_device_t:s0 
/var/named/chroot/dev/zero                         character device   system_u:object_r:zero_device_t:s0 
/usr/sbin/unbound-checkconf                        regular file       system_u:object_r:named_exec_t:s0 
/var/named/chroot/dev/random                       character device   system_u:object_r:random_device_t:s0 
/var/run/systemd/initctl/fifo                      named pipe         system_u:object_r:initctl_t:s0 
/var/named/chroot/etc/rndc\.key                    regular file       system_u:object_r:dnssec_t:s0 
/usr/share/munin/plugins/named                     regular file       system_u:object_r:services_munin_plugin_exec_t:s0 
/var/named/chroot_sdb/dev/null                     character device   system_u:object_r:null_device_t:s0 
/var/named/chroot_sdb/dev/zero                     character device   system_u:object_r:zero_device_t:s0 
/var/named/chroot/etc/localtime                    regular file       system_u:object_r:locale_t:s0 
/var/named/chroot/etc/named\.conf                  regular file       system_u:object_r:named_conf_t:s0 
/var/named/chroot_sdb/dev/random                   character device   system_u:object_r:random_device_t:s0 
/etc/named\.caching-nameserver\.conf               regular file       system_u:object_r:named_conf_t:s0 
/usr/lib/systemd/systemd-hostnamed                 regular file       system_u:object_r:systemd_hostnamed_exec_t:s0 
/var/named/chroot/var/named/named\.ca              regular file       system_u:object_r:named_conf_t:s0 
/var/named/chroot/etc/named\.root\.hints           regular file       system_u:object_r:named_conf_t:s0 
/var/named/chroot/etc/named\.caching-nameserver\.conf regular file       system_u:object_r:named_conf_t:s0 
/var/named/chroot/lib64 = /usr/lib
/var/named/chroot/usr/lib64 = /usr/lib
```

И сравниваем с нашей конфигурацией:

```shell
ls -lZa /etc/named*
```

```log
-rw-r-----. root named system_u:object_r:named_conf_t:s0 /etc/named.conf
-rw-r--r--. root named system_u:object_r:etc_t:s0       /etc/named.iscdlv.key
-rw-r-----. root named system_u:object_r:named_conf_t:s0 /etc/named.rfc1912.zones
-rw-r--r--. root named system_u:object_r:etc_t:s0       /etc/named.root.key
-rw-r--r--. root named system_u:object_r:etc_t:s0       /etc/named.zonetransfer.key

/etc/named:
drw-rwx---. root named system_u:object_r:etc_t:s0       .
drwxr-xr-x. root root  system_u:object_r:etc_t:s0       ..
drw-rwx---. root named unconfined_u:object_r:etc_t:s0   dynamic
-rw-rw----. root named system_u:object_r:etc_t:s0       named.50.168.192.rev
-rw-rw----. root named system_u:object_r:etc_t:s0       named.dns.lab
-rw-rw----. root named system_u:object_r:etc_t:s0       named.dns.lab.view1
-rw-rw----. root named system_u:object_r:etc_t:s0       named.newdns.lab
```

Похоже, что-то пошло не так, когда инженер писал конфигурацию. В [документации](<https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/sect-managing_confined_services-bind-configuration_examples/>) говорится, что мы должны размещать файлы динамических зон в `/var/named/dynamic`. Вдобавок к `/etc/named` и `/etc/namd/dynamic` применяются странные разрешения.  
Исправляем это, обновив сценарий плейбука:

1. Для хоста `ns01` создаём переменную `named_dynamic_path` со значением `/var/named/dynamic`.
2. Задаём путь к динамическим зонам как переменную `named_dynamic_path` в соответствующих задачах.
3. Установливаем правильные разрешения для `/etc/named` (`0750` вместо `0670`) в задаче `set /etc/named permissions`.
4. Переименуем задачу в `set /etc/named/dynamic permissions` в `set "{{ named_dynamic_path }}" permissions`
5. Зададим правильные разрешения для `/etc/named` (`0770` вместо `0670`) в задаче `set "{{ named_dynamic_path }}" permissions`.
6. Заменим config `named.conf` шаблоном `named.conf.j2`
7. В named.conf.j2 параметризуруем путь к динамическим зонам значением переменной named_dynamic_path.
8. Добавим блок с применением контекста selinux к пути динамической зоны. Выполнение может быть включено или выключено с помощью переменной named_selinux.
9. Перед тестами перезагрузить `ns01`.

Теперь у нас есть файлы динамической зоны в правильном месте `/var/named/dynamic`.

Все тесты пройдены.
