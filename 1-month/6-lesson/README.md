# Домашнее задание №6

## Размещаем свой RPM в своем репозитории

### Задачи

1. Создать свой RPM (можно взять свое приложение, либо собрать к примеру апач с определенными опциями)
2. Создать свой репо и разместить там свой RPM  

Реализовать это все либо в вагранте, либо развернуть у себя через nginx и дать ссылку на репо.  

### Выполнение

### Подготовить папку для репозитория
  
  ```shell
  sudo mkdir -p /usr/share/nginx/html/repo
  ```

### Скопировать nginx rpm в созданую папку

  ```shell
  sudo cp rpmbuild/RPMS/x86_64/nginx-1.18.0-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo/
  ```

### Загрузить percona server

  ```shell
  sudo wget https://repo.percona.com/yum/percona-release-latest.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
  ```

### Создать репозиторий с помощью команды `createrepo`

  ```shell
  sudo createrepo /usr/share/nginx/html/repo/
  ```

  ```log
  Spawning worker 0 with 1 pkgs
  Spawning worker 1 with 1 pkgs
  Spawning worker 2 with 0 pkgs
  Spawning worker 3 with 0 pkgs
  Workers Finished
  Saving Primary metadata
  Saving file lists metadata
  Saving other metadata
  Generating sqlite DBs
  Sqlite DBs complete
  ```

Структура папки для репозитория

```log
/usr/share/nginx/html/repo/
├── nginx-1.18.0-1.el7.ngx.x86_64.rpm
├── percona-release-0.1-6.noarch.rpm
└── repodata
    ├── 02e663eaa2a4c4ab6b90977099c0eb14849653eaa79c3d1b395ffc063d7266ec-filelists.sqlite.bz2
    ├── 2286dfa2846ed01d616980d8a6ced890dad6d6dfbdaa4c2c13c04fdd0bccaba2-other.xml.gz
    ├── 4cd92d9f8f3d750bb720c372d66966d4b139c879ba0b3b3a099afa24100c7378-primary.xml.gz
    ├── 5f7a53912a7cf45a864b4615cee8f7305810d9b58bb3d88eea1f10d34ce61e05-filelists.xml.gz
    ├── 68b50b1769b97d07ed03dc976f53e4490e78d8f719c04ce42871d39b745e4f81-primary.sqlite.bz2
    ├── fee396eb841db8f37fddfbefe604db3ef0ae7d4468fb6702166cd16960895781-other.sqlite.bz2
    └── repomd.xml

1 directory, 9 files
```

### Конфигурирую nginx

Добавить `autoindex on;` в раздел `location /`, перегрузить nginx.

```shell
sudo sed -i '/index  index.html index.htm;/ a autoindex on;' /etc/nginx/conf.d/default.conf
sudo nginx -t && sudo nginx -s reload
```

```log
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Проверить результат

```shell
curl -a http://localhost/repo/
```

```html
<html>
<head><title>Index of /repo/</title></head>
<body>
<h1>Index of /repo/</h1><hr><pre><a href="../">../</a>
<a href="repodata/">repodata/</a>                                          24-Feb-2021 10:29                   -
<a href="nginx-1.18.0-1.el7.ngx.x86_64.rpm">nginx-1.18.0-1.el7.ngx.x86_64.rpm</a>                  24-Feb-2021 10:22             2022124
<a href="percona-release-0.1-6.noarch.rpm">percona-release-0.1-6.noarch.rpm</a>                   13-Jun-2018 06:34               14520
</pre><hr></body>
</html>
```

### Проверить репозиторий

Добавить репозиторий в `/etc/yum.repos.d`

```shell
cat << EOF | sudo tee /etc/yum.repos.d/otus.repo
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
```

Убедиться, что репозиторий в состоянии `enabled`

```shell
yum repolist enabled | grep otus
```

```log
otus  otus-linux  2
```

Переустановить nginx из своего репозитория

```shell
sudo yum reinstall -y nginx --disablerepo="*" --enablerepo=otus
```

```log
Загружены модули: fastestmirror
Loading mirror speeds from cached hostfile
Разрешение зависимостей
--> Проверка сценария
---> Пакет nginx.x86_64 1:1.18.0-1.el7.ngx помечен для переустановки
--> Проверка зависимостей окончена

Зависимости определены

================================================================================
 Package        Архитектура     Версия                      Репозиторий   Размер
================================================================================
Переустановка:
 nginx          x86_64          1:1.18.0-1.el7.ngx          otus          1.9 M

Итого за операцию
================================================================================
Переустановить  1 пакет

Объем загрузки: 1.9 M
Объем изменений: 5.9 M
Downloading packages:
No Presto metadata available for otus
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Установка   : 1:nginx-1.18.0-1.el7.ngx.x86_64                             1/1 
  Проверка    : 1:nginx-1.18.0-1.el7.ngx.x86_64                             1/1 

Установлено:
  nginx.x86_64 1:1.18.0-1.el7.ngx                                               

Выполнено!
```

Список пакетов в кастомном репозитории:

```shell
sudo yum repo-pkgs otus list all
```

```log
Загружены модули: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.sale-dedic.com
 * elrepo: mirror.yandex.ru
 * extras: mirror.reconn.ru
 * updates: mirror.reconn.ru
Установленные пакеты
nginx.x86_64                                  1:1.18.0-1.el7.ngx                        @otus
Доступные пакеты
percona-release.noarch                        0.1-6                                     otus
```
