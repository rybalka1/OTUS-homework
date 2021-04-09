# Задание 1: nginx

Запустить nginx на нестандартном порту 3-мя разными способами:

- переключатели setsebool;
- добавление нестандартного порта в имеющийся тип;
- формирование и установка модуля SELinux.
- README с описанием каждого решения (скриншоты и демонстрация приветствуются).

## Экспериментируем с nginx selinux

Получаем информацию о selinux процессах:

```shell
ps auxZ | grep nginx
```

```log
system_u:system_r:httpd_t:s0    root     22573  0.0  0.7  41416  3508 ?        Ss   21:42   0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
system_u:system_r:httpd_t:s0    nginx    22774  0.0  1.0  74464  5184 ?        S    21:42   0:00 nginx: worker process
```

Домен nginx selinux - это `httpd_t`. Это **source** домен.

>Примечание: некоторые полезные опции утилиты `sesearch`

```shell
EXPRESSIONS:
  -s NAME, --source=NAME    rules with type/attribute NAME as source
  -t NAME, --target=NAME    rules with type/attribute NAME as target
  -p P1[,P2,...], --perm=P1[,P2...]
                            rules with the specified permission
  -b NAME, --bool=NAME      conditional rules with NAME in the expression
RULE_TYPES:
  -A, --allow               allow rules
OPTIONS:
  -d, --direct
```

Проверяем допустимые типы nginx **target**:

```shell
sesearch -s httpd_t -Ad
```

Вывод в урезаном виде, потому, что очень длинный.

Проверяем, какой тип использует tcp-порт `8080` (почему nginx уже работает на порту 8080 без каких-либо изменений конфигурации selinux)

```shell
semanage port --list | grep 8080
```

```log
http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
```

Проверяем, что nginx биндится и коннектится к портам `http_cache_port_t`:

```shell
sesearch -s httpd_t -t http_cache_port_t -Ad
```

```log
Found 2 semantic av rules:
   allow httpd_t http_cache_port_t : tcp_socket name_bind ; 
   allow httpd_t http_cache_port_t : tcp_socket name_connect ;
```

Смотрим какие таргеты имеют разрешение **name_bind**

```shell
sesearch -s httpd_t -p name_bind -Ad
```

```log
Found 12 semantic av rules:
   allow httpd_t puppet_port_t : tcp_socket name_bind ; 
   allow httpd_t jboss_management_port_t : tcp_socket name_bind ; 
   allow httpd_t jboss_messaging_port_t : tcp_socket name_bind ; 
   allow httpd_t http_cache_port_t : tcp_socket name_bind ; 
   allow httpd_t ntop_port_t : tcp_socket name_bind ; 
   allow httpd_t http_port_t : udp_socket name_bind ; 
   allow httpd_t http_port_t : tcp_socket name_bind ; 
   allow httpd_t ephemeral_port_type : tcp_socket name_bind ; 
   allow httpd_t ephemeral_port_type : udp_socket name_bind ; 
   allow httpd_t ftp_port_t : tcp_socket name_bind ; 
   allow httpd_t commplex_main_port_t : tcp_socket name_bind ; 
   allow httpd_t preupgrade_port_t : tcp_socket name_bind ;
```

У каких таргетов nginx есть разрешение **name_connect**

```shell
sesearch -s httpd_t -p name_connect -Ad
```

```log
Found 28 semantic av rules:
   allow httpd_t gopher_port_t : tcp_socket name_connect ; 
   allow httpd_t zabbix_port_t : tcp_socket name_connect ; 
   allow httpd_t squid_port_t : tcp_socket name_connect ; 
   allow httpd_t ephemeral_port_type : tcp_socket name_connect ; 
   allow httpd_t ephemeral_port_type : tcp_socket name_connect ; 
   allow httpd_t ephemeral_port_type : tcp_socket name_connect ; 
   allow httpd_t smtp_port_t : tcp_socket name_connect ; 
   allow httpd_t osapi_compute_port_t : tcp_socket name_connect ; 
   allow httpd_t mongod_port_t : tcp_socket name_connect ; 
   allow httpd_t pop_port_t : tcp_socket name_connect ; 
   allow httpd_t ftp_port_t : tcp_socket name_connect ; 
   allow httpd_t ftp_port_t : tcp_socket name_connect ; 
   allow httpd_t http_cache_port_t : tcp_socket name_connect ; 
   allow httpd_t port_type : tcp_socket name_connect ; 
   allow httpd_t ocsp_port_t : tcp_socket name_connect ; 
   allow httpd_t kerberos_port_t : tcp_socket name_connect ; 
   allow httpd_t mysqld_port_t : tcp_socket name_connect ; 
   allow httpd_t mssql_port_t : tcp_socket name_connect ; 
   allow httpd_t postgresql_port_t : tcp_socket name_connect ; 
   allow httpd_t mythtv_port_t : tcp_socket name_connect ; 
   allow httpd_t oracle_port_t : tcp_socket name_connect ; 
   allow httpd_t cobbler_port_t : tcp_socket name_connect ; 
   allow httpd_t memcache_port_t : tcp_socket name_connect ; 
   allow httpd_t memcache_port_t : tcp_socket name_connect ; 
   allow httpd_t gds_db_port_t : tcp_socket name_connect ; 
   allow httpd_t ldap_port_t : tcp_socket name_connect ; 
   allow httpd_t http_port_t : tcp_socket name_connect ; 
   allow httpd_t http_port_t : tcp_socket name_connect ;
```

Разница между разрешениями name_bind и name_connect:
> Когда приложение подключается к порту, проверяется разрешение name_connect. Однако, когда приложение привязывается к порту, проверяется разрешение name_bind.

Получить все порты, которые nginx может присвоить name_bind

```shell
sesearch -s httpd_t -p name_bind -Ad | awk '$2=/httpd_t/ {print $3}' | xargs -I{} sh -c "semanage port --list | grep {}"
```

```log
puppet_port_t                  tcp      8140
jboss_management_port_t        tcp      4447, 4712, 7600, 9123, 9990, 9999, 18001
jboss_management_port_t        udp      4712, 9123
jboss_messaging_port_t         tcp      5445, 5455
http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
http_cache_port_t              udp      3130
ntop_port_t                    tcp      3000-3001
ntop_port_t                    udp      3000-3001
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
ftp_port_t                     tcp      21, 989, 990
ftp_port_t                     udp      989, 990
tftp_port_t                    udp      69
commplex_main_port_t           tcp      5000
commplex_main_port_t           udp      5000
preupgrade_port_t              tcp      8099
```

Если мы хотим провести эксперименты придерживаясь задания, то нам нужно прослушивать TCP-порт из списка выше. Например, порт 8081:

```shell
semanage port --list | grep 8081
```

```log
transproxy_port_t              tcp      8081
```

Итак, теперь мы устанавливаем nginx для прослушивания TCP-порта `8081`.

## Анализ-1

- `sealert` - анализировать и распечатывать читаемые оповещения selinux

```shell
sealert -a /var/log/audit/audit.log
```

```log
100% done
found 1 alerts in /var/log/audit/audit.log
--------------------------------------------------------------------------------

SELinux is preventing /usr/sbin/nginx from name_bind access on the tcp_socket port 8081.

*****  Plugin catchall (100. confidence) suggests   **************************

If you believe that nginx should be allowed name_bind access on the port 8081 tcp_socket by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'nginx' --raw | audit2allow -M my-nginx
# semodule -i my-nginx.pp


Additional Information:
Source Context                system_u:system_r:httpd_t:s0
Target Context                system_u:object_r:transproxy_port_t:s0
Target Objects                port 8081 [ tcp_socket ]
Source                        nginx
Source Path                   /usr/sbin/nginx
Port                          8081
Host                          <Unknown>
Source RPM Packages           nginx-1.19.1-1.el7.ngx.x86_64
Target RPM Packages           
Policy RPM                    selinux-policy-3.13.1-266.el7_8.1.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Enforcing
Host Name                     centos-7
Platform                      Linux centos-7 3.10.0-1127.el7.x86_64 #1 SMP Tue
                              Apr 8 22:24:32 MSK 2021 x86_64 x86_64
Alert Count                   1
First Seen                    2021-04-08 22:24:32 MSK
Last Seen                     2021-04-08 22:24:32 MSK
Local ID                      bfc6efca-3350-4034-9f85-b029fd7d224e

Raw Audit Messages
type=AVC msg=audit(1597419333.68:1080): avc:  denied  { name_bind } for  pid=22521 comm="nginx" src=8081 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:transproxy_port_t:s0 tclass=tcp_socket permissive=0


type=SYSCALL msg=audit(1597419333.68:1080): arch=x86_64 syscall=bind success=no exit=EACCES a0=7 a1=555f5f016da0 a2=10 a3=7fffe948eb30 items=0 ppid=1 pid=22521 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm=nginx exe=/usr/sbin/nginx subj=system_u:system_r:httpd_t:s0 key=(null)

Hash: nginx,httpd_t,transproxy_port_t,tcp_socket,name_bind
```

- `audit2why` - переводит сообщения аудита SELinux в описание причины отказа в доступе (audit2allow -w)

Теперь мы получаем сообщение об ошибке Permission denied, когда пытаемся запустить nginx на порту 8081.

Сначала временно отключаем selinux для nginx

```shell
semanage permissive -a httpd_t
```

Затем запускаем nginx и проверяем, что nginx запущен.

```shell
systemctl restart nginx
systemctl status nginx
```

```log
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2021-03-26 10:57:16 MSK; 4s ago
...
```

Анализируем audit.log утилитой `audit2why`

```shell
audit2why < /var/log/audit/audit.log
```

```log
type=AVC msg=audit(1597263536.671:1016): avc:  denied  { name_bind } for  pid=5773 comm="nginx" src=8081 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:transproxy_port_t:s0 tclass=tcp_socket permissive=0

        Was caused by:
                Missing type enforcement (TE) allow rule.

                You can use audit2allow to generate a loadable module to allow this access.
```

## Обходной путь

Временно отключаем selinux для nginx

```shell
semanage permissive -a httpd_t
```

Вернуть как было: отключить временное разрешение:

```shell
semanage permissive -d httpd_t
```

## Модуль политики SELinux

Узнаём причину:

```shell
grep 1597263536.671:1016 /var/log/audit/audit.log | audit2why
```

```log
type=AVC msg=audit(1597263536.671:1016): avc:  denied  { name_bind } for  pid=5773 comm="nginx" src=8081 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:transproxy_port_t:s0 tclass=tcp_socket permissive=0

        Was caused by:
                Missing type enforcement (TE) allow rule.

                You can use audit2allow to generate a loadable module to allow this access.
```

Некоторые полезные опции для `audit2allow`

```shell
  -M MODULE_PACKAGE, --module-package=MODULE_PACKAGE
                        generate a module package - conflicts with -o and -m
```

Создаём пакет модуля:

```shell
grep 1597263536.671:1016 /var/log/audit/audit.log | audit2allow -M httpd_add --debug
```

```log
******************** IMPORTANT ***********************
To make this policy package active, execute:

semodule -i httpd_add.pp
```

Запускаем модуль:

```shell
semodule -i httpd_add.pp
```

Отключить разрешающий режим для `httpd_t`

```shell
semanage permissive -d httpd_t
```

```log
libsemanage.semanage_direct_remove_key: Removing last permissive_httpd_t module (no other permissive_httpd_t module exists at another priority).
```

Теперь nginx запускается с ошибками w/o:

```shell
systemctl start nginx
systemctl status nginx
```

```log
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed Fri Thu 2021-04-08 17:54:42 MSK; 3s ago
```

После перезагрузки результат такой же!

Другой способ - воспользоваться рекомендацией от `sealert`:

```shell
ausearch -c 'nginx' --raw | audit2allow -M my-nginx
cat my-nginx.te
```

Видите, что будет делать политика?

```conf
module my-nginx 1.0;

require {
        type httpd_t;
        type transproxy_port_t;
        class tcp_socket name_bind;
}

#============= httpd_t ==============
allow httpd_t transproxy_port_t:tcp_socket name_bind;
```

Отлично!!!

```shell
semodule -i my-nginx.pp
```

Этот способ не рекомендуется или должен использоваться с осторожностью. Всегда нужно обращать внимание на то, что делает сгенерированная политика, потому что ваш сервис действительно может быть скомпрометирован!

## Обновить существующий тип - 1

Также возможно добавить порт 8081 к существующему типу.  
Получаем список существующих разрешенных типов для httpd_t:

```shell
sesearch -s httpd_t -p name_bind -Ad
```

```log
Found 12 semantic av rules:
   allow httpd_t puppet_port_t : tcp_socket name_bind ; 
   allow httpd_t jboss_management_port_t : tcp_socket name_bind ; 
   allow httpd_t jboss_messaging_port_t : tcp_socket name_bind ; 
   allow httpd_t http_cache_port_t : tcp_socket name_bind ; 
   allow httpd_t ntop_port_t : tcp_socket name_bind ; 
   allow httpd_t http_port_t : udp_socket name_bind ; 
   allow httpd_t http_port_t : tcp_socket name_bind ; 
   allow httpd_t ephemeral_port_type : tcp_socket name_bind ; 
   allow httpd_t ephemeral_port_type : udp_socket name_bind ; 
   allow httpd_t ftp_port_t : tcp_socket name_bind ; 
   allow httpd_t commplex_main_port_t : tcp_socket name_bind ; 
   allow httpd_t preupgrade_port_t : tcp_socket name_bind ;
```

Мы будем использовать тип http_port_t.  
Получаем разрешенные порты для http_port_t

```shell
semanage port --list | grep http_port_t
```

```log
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
```

>ПРИМЕЧАНИЕ: Некоторые полезные опции для `semanage`

```shell
  -a, --add             Add a record of the port object type
  -t TYPE, --type TYPE  SELinux Type for the object
  -p PROTO, --proto PROTO
                        Protocol for the specified port (tcp|udp) or internet
                        protocol version for the specified node (ipv4|ipv6).
```

Добавляем порт 8081 к типу http_port_t

```shell
semanage port --add --type http_port_t --proto tcp 8081 
```

```log
ValueError: Port tcp/8081 already defined
```

ОШИБКА!!!!

---

Попробуем использовать порт 8085, который имеет контекст:

```shell
seinfo --portcon=8085
```

```log
        portcon tcp 1024-32767 system_u:object_r:unreserved_port_t:s0
        portcon udp 1024-32767 system_u:object_r:unreserved_port_t:s0
        portcon sctp 1024-65535 system_u:object_r:unreserved_port_t:s0
```

Меняем порт на `8085`:

- создать новый сценарий molecule (./roles/ansible-role-nginx/molecule/default)

## Анализ-2

```shell
LANG=C sealert -a /var/log/audit/audit.log
```

```log
100% done
found 1 alerts in /var/log/audit/audit.log
--------------------------------------------------------------------------------

SELinux is preventing /usr/sbin/nginx from name_bind access on the tcp_socket port 8085.

*****  Plugin bind_ports (92.2 confidence) suggests   ************************

If you want to allow /usr/sbin/nginx to bind to network port 8085
Then you need to modify the port type.
Do
# semanage port -a -t PORT_TYPE -p tcp 8085
    where PORT_TYPE is one of the following: http_cache_port_t, http_port_t, jboss_management_port_t, jboss_messaging_port_t, ntop_port_t, puppet_port_t.

*****  Plugin catchall_boolean (7.83 confidence) suggests   ******************

If you want to allow nis to enabled
Then you must tell SELinux about this by enabling the 'nis_enabled' boolean.

Do
setsebool -P nis_enabled 1

*****  Plugin catchall (1.41 confidence) suggests   **************************

If you believe that nginx should be allowed name_bind access on the port 8085 tcp_socket by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'nginx' --raw | audit2allow -M my-nginx
# semodule -i my-nginx.pp


Additional Information:
Source Context                system_u:system_r:httpd_t:s0
Target Context                system_u:object_r:unreserved_port_t:s0
Target Objects                port 8085 [ tcp_socket ]
Source                        nginx
Source Path                   /usr/sbin/nginx
Port                          8085
Host                          <Unknown>
Source RPM Packages           nginx-1.19.1-1.el7.ngx.x86_64
Target RPM Packages           
Policy RPM                    selinux-policy-3.13.1-266.el7_8.1.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Enforcing
Host Name                     centos-7
Platform                      Linux centos-7 3.10.0-957.12.2.el7.x86_64 #1 SMP
                              Tue Apr 8 22:24:32 MSK 2021 x86_64 x86_64
Alert Count                   1
First Seen                    2021-04-08 22:24:32 MSK
Last Seen                     2021-04-08 22:24:32 MSK
Local ID                      555705d6-de08-4e0a-85f8-c29e53a87ba1

Raw Audit Messages
type=AVC msg=audit(1597598999.789:1052): avc:  denied  { name_bind } for  pid=5908 comm="nginx" src=8085 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0


type=SYSCALL msg=audit(1597598999.789:1052): arch=x86_64 syscall=bind success=no exit=EACCES a0=7 a1=5632e8e42da0 a2=10 a3=7ffd76eb2cd0 items=0 ppid=1 pid=5908 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm=nginx exe=/usr/sbin/nginx subj=system_u:system_r:httpd_t:s0 key=(null)

Hash: nginx,httpd_t,unreserved_port_t,tcp_socket,name_bind
```

Есть три варианта решения проблемы:

- Если мы хотим разрешить /usr/sbin/nginx связываться с сетевым портом 8085, нам необходимо изменить тип порта (это возможно, потому что порт `8085` принадлежит типу selinux `unreserved_port_t`)
- Если мы хотим разрешить включение nis, мы должны сообщить об этом SELinux, включив логическое значение nis_enabled.
- Если мы считаем, что nginx должен иметь доступ name_bind к порту 8085 tcp_socket по умолчанию, то мы должны сообщить об этом как об ошибке.
- Мы можем создать модуль локальной политики, чтобы разрешить этот доступ. (Это создаст политику SELinux, которая позволяет nginx связываться со **всеми портами unreserved_port_t**. Действительно ли это то, что мы хотим?)

## Обновить существующий тип - 2

Если нам необходимо разрешить /usr/sbin/nginx связываться с сетевым портом 8085, то мы должны изменить тип порта.

```shell
# semanage port -a -t PORT_TYPE -p tcp 8085
    where PORT_TYPE is one of the following: http_cache_port_t, http_port_t, jboss_management_port_t, jboss_messaging_port_t, ntop_port_t, puppet_port_t.
```

Далее:

```shell
semanage port -a -t http_port_t -p tcp 8085
```

Проверяем:

```shell
systemctl start nginx
systemctl status nginx
```

```log
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2020-08-16 20:41:41 UTC; 4s ago
...

```

Проверяем доступность контента сайта:

```shell
curl 127.0.0.1:8085
```

Ответ от nginx:

```log
centos-7  ^_^
```

## Утилита sebool

Используется если мы хотим, чтобы nis был включен.  
Сначала мы должны сообщить об этом SELinux, включив логическое значение nis_enabled.

Что делает nis_enabled?

```shell
semanage boolean --list | grep nis_enabled
```

```log
nis_enabled                    (вкл. , вкл.)  Allow nis to enabled
```

Запускаем:

```shell
setsebool -P nis_enabled 1
```

После этого `nginx` запускается без ошибок:

```shell
systemctl start nginx
```

Я думаю, что это не лучший способ, потому что логическое значение nis_enabled дает слишком много разрешений.

```shell
semanage boolean -l | grep nis_enabled | head
```

```log
sesearch -Ad -b nis_enabled | head
Found 3797 semantic av rules:
   allow sshd_t sshd_t : udp_socket { ioctl read write create getattr setattr lock append bind connect getopt setopt shutdown } ; 
   allow sshd_t sshd_t : udp_socket { ioctl read write create getattr setattr lock append bind connect getopt setopt shutdown } ; 
   allow denyhosts_t denyhosts_t : udp_socket { ioctl read write create getattr setattr lock append bind connect getopt setopt shutdown } ; 
   allow newrole_t port_t : udp_socket name_bind ; 
   allow xdm_t server_packet_t : packet recv ; 
   allow xdm_t server_packet_t : packet send ; 
   allow pwauth_t pwauth_t : tcp_socket { ioctl read write create getattr setattr lock append bind connect listen accept getopt setopt shutdown } ; 
   allow secadm_su_t port_t : tcp_socket name_connect ; 
   allow secadm_su_t port_t : tcp_socket name_bind ;
...
```

но когда мы настраиваем какую-то стандартную роль сервера, это вполне рабочий вариант.
