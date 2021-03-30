# Домашнее задание №12

## Пользователи и группы. Авторизация и аутентификация

1. Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников
2. дать конкретному пользователю права работать с докером и возможность рестартить докер сервис

---

## Выполнение

## Задание 1: PAM

Поскольку это тестовая роль, она была инициализирована с помощью `ansible-galaxy`, кроме `molecule`.

```shell
ansible-galaxy role init ansible-role-<rolename>
```

1. Используем `pam_time` [roles/ansible-role-pamtime/](./roles/ansible-role-pamtime/). Модуль используется только при ограничении доступа прользователей, а не групп пользователей.
2. Используем `pam_exec` [./roles/ansible-role-pamexec/](./roles/ansible-role-pamexec/).

### Запуск

Предполагается, что установлен пакет `ansible>=2.9`. Если пакет не установлен, то устанвливаем:

```shell
# Install make
sudo apt install make
# Create venv
make venv
# Activate venv
source .venv/bin/activate
```

Запускаем виртуальное окружение vagrant:

```shell
vagrant up
```

Экземпляр будет подготовлен автоматически. Будет создано два пользователя:

- `testuser` член группы `users`
- `testadmin` член группы `admin`

Также пользователь vagrant будет добавлен в группу admin, чтобы не потерять возможность подключиться в выходные.

### Тестирование

Устанавливаем дату 2020-08-01 (Суббота)

Побуем подключиться как `testadmin`

```shell
ssh -i ./.vagrant/machines/less12-aaa/virtualbox/private_key -p 2222 testadmin@127.0.0.1
```

Подключились

```log
[testadmin@less12-aaa ~]$ logout
Connection to 127.0.0.1 closed.
```

Побуем подключиться как `testuser`

```shell
ssh -i ./.vagrant/machines/less12-aaa/virtualbox/private_key -p 2222 testuser@127.0.0.1 
```

```log
/usr/local/bin/check-week-day.sh failed: exit code 1
Connection closed by 127.0.0.1 port 2222
```

### Проблемы

Модуль pam_time не работает с именами групп, разрешены только имена пользователей, для её решения можно использовать другой модуль, например `pam_exec`

---

## Задание 2: docker

Создал роль [ansible-role-dockermgr](./roles/ansible-role-dockermgr/) которая:

1. Установит docker (если переменная `dockermgr_install` true).  
2. Разрешит пользователям, перечисленным в списке `dockermgr_managers:`, доступ `r/w` к `/var/run/docker.sock` после того, как служба Docker начнет использовать ACL.
3. Разрешит управление службами systemd (запуск/остановка/перезапуск и т.д.) для пользователей, перечисленных в списке `dockermgr_managers:`. Добавит правило PolKit, которое разрешает этим пользователям использовать `org.freedesktop.systemd1.manage-units`.

### Запускаем

Предполагается, что установлен пакет `ansible>=2.9`. Если пакет не установлен, то устанвливаем:

```shell
# Install make
sudo apt install make
# Create venv
make venv
# Activate venv
source .venv/bin/activate
```

Запускаем инстанс vagrant

```shell
vagrant up
```

Инстанс будет подготовлен автоматически

В разделе _some tests_ в секции `post_task:` имеются несколько тестов [provision.yml](./provision.yml)

### Проверка

Заходим в виртуальное окружение vagrant

```shell
vagrant ssh
```

Проверяем что пользователь `vagrant` может выполнять команды `docker`

```shell
[vagrant@less12-aaa ~]$ docker info
```

```log
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 1.13.1
Storage Driver: overlay2
 Backing Filesystem: xfs
 Supports d_type: true
 Native Overlay Diff: true
Logging Driver: journald
Cgroup Driver: systemd
Plugins: 
 Volume: local
 Network: bridge host macvlan null overlay
Swarm: inactive
Runtimes: runc docker-runc
Default Runtime: docker-runc
Init Binary: /usr/libexec/docker/docker-init-current
containerd version:  (expected: aa8187dbd3b7ad67d8e5e3a15115d3eef43a7ed1)
runc version: 66aedde759f33c190954815fb765eedc1d782dd9 (expected: 9df8b306d01f59d3a8029be411de015b7304dd8f)
init version: fec3683b971d9c3ef73f284f176672c44b448662 (expected: 949e6facb77383876aeff8a6944dde66b3089574)
Security Options:
 seccomp
  WARNING: You're not using the default seccomp profile
  Profile: /etc/docker/seccomp.json
Kernel Version: 5.6.11-1.el7.elrepo.x86_64
Operating System: CentOS Linux 7 (Core)
OSType: linux
Architecture: x86_64
Number of Docker Hooks: 3
CPUs: 2
Total Memory: 479.8 MiB
Name: less12-aaa
ID: F3DQ:23S4:UQPL:4EOB:GGWC:LPH2:7PBE:UDY3:PDI7:WALS:ANIZ:DM6K
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
WARNING: bridge-nf-call-iptables is disabled
WARNING: bridge-nf-call-ip6tables is disabled
Experimental: false
Insecure Registries:
 127.0.0.0/8
Live Restore Enabled: false
Registries: docker.io (secure)
```

Проверяем, что пользователь `vagrant` может перезапустить службу `docker`

```shell
[vagrant@less12-aaa ~]$ systemctl restart docker.service
[vagrant@less12-aaa ~]$
```
