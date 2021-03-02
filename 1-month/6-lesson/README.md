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
  sudo wget -q http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
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
    ├── 3ee366b6d643c5bedcf1e17b10c455f1f4ce60938704bbf0c41720a89163ed59-filelists.sqlite.bz2
    ├── 5459dfa61666067f8da15de595281c7ddb2d67c85bf860e7f0ee741701ab056d-other.sqlite.bz2
    ├── 5c8f283c72eebc13f1dabdf430b4706a68fadf9d386dfbdcc9fbb6e2eb79b7d0-primary.xml.gz
    ├── 6524ce47a12c282b6ba132deb918183f5216cc57a51f4e193ae76c4680bbd982-primary.sqlite.bz2
    ├── a29d879599ccbf765631d406d9df19be7cf53eb241ce6e0e8da971be980112c2-filelists.xml.gz
    ├── d04190f2cd63fcaa9c37027d7d2d385778dc7aa146a4a26d18402517365c32a1-other.xml.gz
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
