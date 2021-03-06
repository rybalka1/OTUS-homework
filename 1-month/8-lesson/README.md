# Домашнее задание №8

## Инициализация системы. Systemd.

Выполнить следующие задания и подготовить развёртывание результата выполнения с использованием Vagrant и Vagrant shell provisioner (или Ansible, на Ваше усмотрение):
Выполнить следующие задания и подготовить развёртывание результата выполнения с использованием Vagrant и Vagrant shell provisioner (или Ansible, на Ваше усмотрение):

1. Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/sysconfig);
2. Из репозитория epel установить spawn-fcgi и переписать init-скрипт на unit-файл (имя service должно называться так же: spawn-fcgi);
3. Дополнить unit-файл httpd (он же apache) возможностью запустить несколько инстансов сервера с разными конфигурационными файлами;  

___

## Выполнение

### 1. Служба мониторинга логов

Сздаём пользователя `logmon` и добавляем его в группу `systemd-journal`

```shell
sudo adduser --no-create-home --no-user-group --gid systemd-journal --shell /usr/sbin/nologin logmon
```

Копируем скрипт `logmon.sh` в папку `/usr/local/bin` и выдаём разрешение на его выполнение:

```shell
sudo cp /vagrant/logmon/logmon.sh /usr/local/bin/logmon.sh
sudo chmod +x /usr/local/bin/logmon.sh
```

Копируем `logmon` файл конфигурации в `/etc/sysconfig`

```shell
sudo cp /vagrant/logmon/logmon /etc/sysconfig/logmon
```

Копируем юнит файл модуля `systemd` в `/etc/systemd/system` и перезапускаем `systemd`

```shell
sudo cp /vagrant/logmon/logmon.service /etc/systemd/system/
sudo systemctl daemon-reload
```

Включаем и запускаем юнит `logmon.service`

```shell
sudo systemctl enable logmon.service
sudo systemctl start logmon.service
```

Проверяем, что получилось, передаём настроенный шадлон в `syslog`

```shell
logger Test message with logmon pattern 'testmsg' in it
```

Проверить созданный файл журнала:

```shell
cat /tmp/logmon.log
```

***Конфигурируем 'logmon'***

Сценарий может быть настроен с помощью переменных среды, хранящихся в `/etc/sysconfig/logmon`

```shell
# Filename to log pattern matches to
LOG=${LOG:-/tmp/logmon.log}
# Read log every $SEC seconds
SEC=${SEC:=30}
# grep template pattern
PATTERN=${PATTERN:-testmsg}
```

***Systemd юнит-файл*** --> [logmon.service](./logmon/logmon.service)

Systemd запускает службу `logmon.sh` от имени пользователя`logmon`.
> ПРИМЕЧАНИЕ: пользователь `logmon` должен быть членом группы `systemd-journal`, чтобы читать все журналы, что мы и проделали ранее.
___

### 2. `spawn-fcgi` юнит-файл

Устанавливаем `spawn-fcgi` и `php-cli` для запуска с сервисом spawn-fcgi

```shell
sudo yum install -y spawn-fcgi php-cli
```

Смотрим содержимое `spawn-fcgi`

```shell
cat /etc/init.d/spawn-fcgi
```

```shell
#!/bin/sh
#
# spawn-fcgi   Start and stop FastCGI processes
#
# chkconfig:   - 80 20
# description: Spawn FastCGI scripts to be used by web servers

### BEGIN INIT INFO
# Provides: 
# Required-Start: $local_fs $network $syslog $remote_fs $named
# Required-Stop: 
# Should-Start: 
# Should-Stop: 
# Default-Start: 
# Default-Stop: 0 1 2 3 4 5 6
# Short-Description: Start and stop FastCGI processes
# Description:       Spawn FastCGI scripts to be used by web servers
### END INIT INFO

# Source function library.
. /etc/rc.d/init.d/functions

exec="/usr/bin/spawn-fcgi"
prog="spawn-fcgi"
config="/etc/sysconfig/spawn-fcgi"

[ -e /etc/sysconfig/$prog ] && . /etc/sysconfig/$prog

lockfile=/var/lock/subsys/$prog

start() {
    [ -x $exec ] || exit 5
    [ -f $config ] || exit 6
    echo -n $"Starting $prog: "
    # Just in case this is left over with wrong ownership
    [ -n "${SOCKET}" -a -S "${SOCKET}" ] && rm -f ${SOCKET}
    daemon "$exec $OPTIONS >/dev/null"
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}

stop() {
    echo -n $"Stopping $prog: "
    killproc $prog
    # Remove the socket in order to never leave it with wrong ownership
    [ -n "${SOCKET}" -a -S "${SOCKET}" ] && rm -f ${SOCKET}
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

restart() {
    stop
    start
}

reload() {
    restart
}

force_reload() {
    restart
}

rh_status() {
    # run checks to determine if the service is running or use generic status
    status $prog
}

rh_status_q() {
    rh_status &>/dev/null
}


case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
        exit 2
esac
exit $?
```

Создаём юнит-файл `spawn-fcgi.service` в `/etc/systemd/system`

***Systemd юнит-файл*** --> [spawn-fcgi.service](https://github.com/rybalka1/OTUS-homework/blob/master/1-month/8-lesson/spawn-fcgi/spawn-fcgi)

```conf
# /etc/systemd/system/spawn-fcgi.service
[Unit]
Description=spawn-fcgi service
After=syslog.target

[Service]
# Type of process running
Type=forking
# For type forking it's need to set PID file location
# %p is the service name in this case
PIDFile=/var/run/%p.pid
# Set process name for logs
SyslogIdentifier=%p
# Path to file with environment variables
EnvironmentFile=/etc/sysconfig/spawn-fcgi
# Run service. OPTIONS is defined in environment file
ExecStart=/usr/bin/spawn-fcgi $OPTIONS

[Install]
WantedBy=multi-user.target
```

Файл окружения, его содержимое

```shell
SOCKET=/var/run/php-fcgi.sock
OPTIONS="-u nobody -g nobody -s $SOCKET -S -M 0600 -C 16 -F 1 -P /var/run/spawn-fcgi.pid -- /usr/bin/php-cgi"
```

Запускаем сервисы `systemd`

```shell
sudo systemctl start spawn-fcgi
sudo systemctl status spawn-fcgi
```

```log
● spawn-fcgi.service - spawn-fcgi service
   Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; disabled; vendor preset: disabled)
   Active: active (running) since Пт 2020-06-12 18:29:22 UTC; 4s ago
  Process: 4195 ExecStart=/usr/bin/spawn-fcgi $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 4196 (php-cgi)
   CGroup: /system.slice/spawn-fcgi.service
           ├─4196 /usr/bin/php-cgi
           ├─4197 /usr/bin/php-cgi
           ├─4198 /usr/bin/php-cgi
           ├─4199 /usr/bin/php-cgi
           ├─4200 /usr/bin/php-cgi
           ├─4201 /usr/bin/php-cgi
           ├─4202 /usr/bin/php-cgi
           ├─4203 /usr/bin/php-cgi
           ├─4204 /usr/bin/php-cgi
           ├─4205 /usr/bin/php-cgi
           ├─4206 /usr/bin/php-cgi
           ├─4207 /usr/bin/php-cgi
           ├─4208 /usr/bin/php-cgi
           ├─4209 /usr/bin/php-cgi
           ├─4210 /usr/bin/php-cgi
           ├─4211 /usr/bin/php-cgi
           └─4212 /usr/bin/php-cgi

июн 12 18:29:22 hw7-systemd systemd[1]: Starting spawn-fcgi service...
июн 12 18:29:22 hw7-systemd spawn-fcgi[4195]: spawn-fcgi: child spawned successfully: PID: 4196
июн 12 18:29:22 hw7-systemd systemd[1]: Started spawn-fcgi service.
```

Для провижининга использую следующие файлы и скрипты:

- `./spawn-fcgi/spawn-fcgi` - файлы конфигурации окружения
- `./spawn-fcgi/spawn-fcgi.service` - systemd сервис файл
- `./scripts/3-spawn-fcgi-service.sh` - устанавливает, включает и запускает сервис `systemd`

***Systemd юнит-файл*** --> [Unit-file for spawn-fcgi](https://github.com/rybalka1/OTUS-homework/blob/master/1-month/8-lesson/spawn-fcgi/spawn-fcgi)
___

### 3. httpd запуск нескольких инстансов

Устанавливаем `httpd`

```shell
sudo yum install -y httpd
```

Исходный httpd юнит-файл `/usr/lib/systemd/system/httpd.service`

```conf
[Unit]
Description=The Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
Documentation=man:httpd(8)
Documentation=man:apachectl(8)

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/httpd
ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
ExecStop=/bin/kill -WINCH ${MAINPID}
# We want systemd to give httpd some time to finish gracefully, but still want
# it to kill httpd after TimeoutStopSec if something went wrong during the
# graceful stop. Normally, Systemd sends SIGTERM signal right after the
# ExecStop, which would kill httpd. We are sending useless SIGCONT here to give
# httpd time to finish.
KillSignal=SIGCONT
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

Исходный `httpd` конфиг `/etc/sysconfig/httpd`

```shell
#
# This file can be used to set additional environment variables for
# the httpd process, or pass additional options to the httpd
# executable.
#
# Note: With previous versions of httpd, the MPM could be changed by
# editing an "HTTPD" variable here.  With the current version, that
# variable is now ignored.  The MPM is a loadable module, and the
# choice of MPM can be changed by editing the configuration file
# /etc/httpd/conf.modules.d/00-mpm.conf.
# 

#
# To pass additional options (for instance, -D definitions) to the
# httpd binary at startup, set OPTIONS here.
#
#OPTIONS=

#
# This setting ensures the httpd process is started in the "C" locale
# by default.  (Some modules will not behave correctly if
# case-sensitive string comparisons are performed in a different
# locale.)
#
LANG=C
```

Создаём новый файл модуля httpd с именем `httpd@.service`. Устанавливаем `Type=forking` и определяем PidFile относительно имени экземпляра.

`/etc/systemd/system/httpd@.service`

```conf
[Unit]
Description=The Apache HTTP Server instance %I
After=network.target remote-fs.target nss-lookup.target
Documentation=man:httpd(8)
Documentation=man:apachectl(8)

[Service]
Type=forking
PIDFile=/var/run/httpd/httpd-%i.pid
EnvironmentFile=/etc/sysconfig/httpd@%i
ExecStart=/usr/sbin/httpd $OPTIONS -c 'PidFile "/var/run/httpd/httpd-%i.pid"'
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
ExecStop=/bin/kill -WINCH ${MAINPID}
# We want systemd to give httpd some time to finish gracefully, but still want
# it to kill httpd after TimeoutStopSec if something went wrong during the
# graceful stop. Normally, Systemd sends SIGTERM signal right after the
# ExecStop, which would kill httpd. We are sending useless SIGCONT here to give
# httpd time to finish.
KillSignal=SIGCONT
PrivateTmp=true

[Install]
RequiredBy=httpd.target
# If httpd.target doesn't exists, comment above uncomment underlying directives
#WantedBy=multi-user.target
```

Также возможно создать httpd.target для управления всеми экземплярами.

`/etc/systemd/system/httpd.target`

```conf
[Unit]
Description=The Apache HTTP Server instances

[Install]
WantedBy=multi-user.target  
```

> Основное различие между директивами `RequiredBy` и `WantedBy` в `[Install]` заключается в том, как отображать статус `target`. Когда определен `WantedBy`, цель становится `active`, если активен только **one instance**. Когда определен `RequiredBy`, цель **active** только тогда, когда активны все экземпляры **all instances**.

Создадим два конфига с разными `serverroot`

```shell
cat << EOF | sudo tee /etc/sysconfig/httpd@8080
LANG=C
OPTIONS=-d /etc/httpd-8080
EOF
cat << EOF | sudo tee /etc/sysconfig/httpd@8081
LANG=C
OPTIONS=-d /etc/httpd-8081
EOF
```

Сздадим `serverroot` директории

```shell
sudo cp -a /etc/httpd /etc/httpd-8080
sudo sed -i 's#^ServerRoot "/etc/httpd"$#ServerRoot "/etc/httpd-8080"#g' /etc/httpd-8080/conf/httpd.conf
sudo sed -i 's#^Listen 80$#Listen 8080#g' /etc/httpd-8080/conf/httpd.conf
sudo cp -a /etc/httpd /etc/httpd-8081
sudo sed -i 's#^ServerRoot "/etc/httpd"$#ServerRoot "/etc/httpd-8081"#g' /etc/httpd-8081/conf/httpd.conf
sudo sed -i 's#^Listen 80$#Listen 8081#g' /etc/httpd-8081/conf/httpd.conf
```

Чтобы запустить экземпляры службы, достаточно создать конфигурацию в `/etc/sysconfig/httpd@<instance>` и запустить службу командой `sudo systemctl start httpd@<instance>.service`.  
Вот список команд для запуска всех сервисов сейчас и при загрузке системы:

```shell
{
    sudo systemctl enable httpd@808{0,1}.service
    sudo systemctl enable httpd.target
    sudo systemctl start httpd.target
}
```

Убедимся, что все службы запустились и работают

```shell
systemctl status httpd.target httpd@808{0,1}.service
```

```log
● httpd.target - The Apache HTTP Server instances
   Loaded: loaded (/etc/systemd/system/httpd.target; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2021-03-04 15:53:36 MSK; 6s ago

● httpd@8080.service - The Apache HTTP Server instance 8080
   Loaded: loaded (/etc/systemd/system/httpd@.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2021-03-04 15:53:36 MSK; 6s ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 12280 (httpd)
   CGroup: /system.slice/system-httpd.slice/httpd@8080.service
           ├─12280 /usr/sbin/httpd -d /etc/httpd-8080 -c PidFile "/var/run/httpd/httpd-8080.pid"
           ├─12281 /usr/sbin/httpd -d /etc/httpd-8080 -c PidFile "/var/run/httpd/httpd-8080.pid"
           ├─12282 /usr/sbin/httpd -d /etc/httpd-8080 -c PidFile "/var/run/httpd/httpd-8080.pid"
           ├─12283 /usr/sbin/httpd -d /etc/httpd-8080 -c PidFile "/var/run/httpd/httpd-8080.pid"
           ├─12284 /usr/sbin/httpd -d /etc/httpd-8080 -c PidFile "/var/run/httpd/httpd-8080.pid"
           └─12285 /usr/sbin/httpd -d /etc/httpd-8080 -c PidFile "/var/run/httpd/httpd-8080.pid"

● httpd@8081.service - The Apache HTTP Server instance 8081
   Loaded: loaded (/etc/systemd/system/httpd@.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2021-03-04 15:53:36 MSK; 6s ago
     Docs: man:httpd(8)
           man:apachectl(8)
  Process: 23836 ExecStart=/usr/sbin/httpd $OPTIONS -c PidFile "/var/run/httpd/httpd-%i.pid" (code=exited, status=0/SUCCESS)
 Main PID: 23837 (httpd)
   CGroup: /system.slice/system-httpd.slice/httpd@8081.service
           ├─23837 /usr/sbin/httpd -d /etc/httpd-8081 -c PidFile "/var/run/httpd/httpd-8081.pid"
           ├─23838 /usr/sbin/httpd -d /etc/httpd-8081 -c PidFile "/var/run/httpd/httpd-8081.pid"
           ├─23839 /usr/sbin/httpd -d /etc/httpd-8081 -c PidFile "/var/run/httpd/httpd-8081.pid"
           ├─23840 /usr/sbin/httpd -d /etc/httpd-8081 -c PidFile "/var/run/httpd/httpd-8081.pid"
           ├─23841 /usr/sbin/httpd -d /etc/httpd-8081 -c PidFile "/var/run/httpd/httpd-8081.pid"
           └─23842 /usr/sbin/httpd -d /etc/httpd-8081 -c PidFile "/var/run/httpd/httpd-8081.pid"
```

Скрипты для провижининга и файлы настройки:  
[4-httpd-service-template.sh](./scripts/4-httpd-service-template.sh)  

- `httpd@.service` - systemd шаблон  
- `httpd.target` - systemd target

`/etc/sysconfig/httpd@*` конфиги генерируются автоматически скриптом провижининга

Задание выполнено.
