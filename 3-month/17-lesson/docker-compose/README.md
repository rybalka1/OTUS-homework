# nginx c php-fpm

Ниже docker compose с nginx и php-fpm

## Настройка окружения

Заходим в директорию 17-lesson/docker-compose

Копируем `.env.example` в файл `.env` и заменяем переменные окружения на свои:

- переменные среды контейнера:
  - `NGINX_STATIC_ROOT` каталог в контейнере nginx со статическим содержимым
  - `NGINX_DEFAULT_SITE_PORT` порт в контейнере который слушает nginx  (`listen` значение директивы)
- compose-related переменные
  - `NGINX_IMAGE_NAME` nginx docker image name
  - `NGINX_IMAGE_TAG` nginx docker image tag
  - `PHP_IMAGE_NAME` php-fpm docker image name
  - `PHP_IMAGE_TAG` php-fpm docker image name

Реализация этой задачи имеет следующую структуру каталогов:

```tree
├── docker-compose.yml
├── nginx
│   ├── Dockerfile
│   ├── templates
│   │   └── phpinfo.conf.template
│   └── www
│       └── index.html
├── php-fpm
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── www
│       └── phpinfo.php
└── README.md

5 directories, 8 files
```

- `docker-compose.yml`: файл для docker-compose
- `nginx`: контекст docker для сервиса nginx
- `nginx/templates`: каталог для шаблонов конфигурации nginx (за вычетом значений переменных среды). Все шаблоны должны иметь суффикс `.template`
- `nginx/www`: директория nginx для статических html файлов
- `php-fpm`: контекст docker для php-fpm сервиса
- `php-fpm/www`: директоря для динамического контекста php

## Запускаем тестовое окружение

Собираем образ:

```shell
docker-compose build
```

Этот пунк те обязательный, нужен только если используется VPN или уже используется такой диапазон IP:

```shell
docker network create my-network --subnet 172.24.24.0/24
```

Запускаем compose:

```shell
docker-compose up -d
```

Проверяем:

```shell
curl 127.0.0.1:8080/phpinfo.php
```

или открываем в браузере http://127.0.0.1:8080/phpinfo.php

Останавливаем compose

```shell
docker-compose down
```

## Публикация своего образа в Docker Hub

Войдиv в Docker Hub (аккаунт должен существовать)

```shell
docker login
```

Build an image

```shell
docker-compose build
```

```log
Building nginx
Sending build context to Docker daemon  5.632kB
Step 1/7 : FROM nginx:1.18.0-alpine
 ---> 684dbf9f01f3
Step 2/7 : LABEL maintainer="Rybalka Dmitrii <rybalka.dmitrii@gmail.com>"
 ---> Using cache
 ---> 8770cc98e979
Step 3/7 : ENV NGINX_STATIC_ROOT=/data/www
 ---> Using cache
 ---> bd4c8044f68a
Step 4/7 : WORKDIR ${NGINX_STATIC_ROOT}
 ---> Using cache
 ---> 7bcd1d2e1892
Step 5/7 : RUN rm /etc/nginx/conf.d/default.conf
 ---> Using cache
 ---> dd76748c1d4b
Step 6/7 : COPY templates /etc/nginx/templates
 ---> Using cache
 ---> 4a0933c42acf
Step 7/7 : COPY www ${NGINX_STATIC_ROOT}
 ---> Using cache
 ---> 11a086553d56
Successfully built 11a086553d56
Successfully tagged rybalka1/nginx-php:1.0.0
Building php-fpm
Sending build context to Docker daemon  4.608kB
Step 1/4 : FROM php:7.4.9-fpm-alpine3.12
 ---> 01e347850069
Step 2/4 : LABEL maintainer="Rybalka Dmitrii <rybalka.dmitrii@gmail.com>"
 ---> Using cache
 ---> 8e0f4a4ed57b
Step 3/4 : COPY www /var/www/html
 ---> Using cache
 ---> 34ba47d2bba0
Step 4/4 : WORKDIR /var/www/html
 ---> Using cache
 ---> a580a1e10a9a
Successfully built a580a1e10a9a
Successfully tagged rybalka1/php-fpm:1.0.0
```

Публикуем образ на Docker Hub:

```shell
docker-compose push
```

```log
Pushing nginx (rybalka1/nginx-php:1.0.0)...
The push refers to repository [docker.io/rybalka1/nginx-php]
c09fef7711f7: Pushed
720ba35f1dd2: Pushed
69a7ce68515d: Pushed
acd0cf1084b8: Pushed
f88365b5c5d3: Mounted from library/nginx
bda4c7e5e442: Mounted from library/nginx
154dfe1bc87d: Mounted from library/nginx
d1cf28aead06: Mounted from library/nginx
9a5d14f9f550: Mounted from library/nginx
1.0.0: digest: sha256:f1712da48ee8b296d620b425a62a2064216e8929a87cee714e97a939ffdb46a6 size: 2188
Pushing php-fpm (rybalka1/php-fpm:1.0.0)...
The push refers to repository [docker.io/rybalka1/php-fpm]
186caeaa964b: Pushed
378b8b8fff6a: Mounted from library/php
88911823ac5d: Mounted from library/php
a7c6f279b07e: Mounted from library/php
0e4882c0ad19: Mounted from library/php
5b139208dd54: Mounted from library/php
76e7b3bdfbef: Mounted from library/php
81c338ff74a3: Mounted from library/php
308ef7bef157: Mounted from library/php
d94df04fea90: Mounted from library/php
50644c29ef5a: Mounted from rybalka1/nginx
1.0.0: digest: sha256:52bf43d019008ee762f8be1c51a301208506cca16deca934c830bff11e98862f size: 2618
```

- <https://hub.docker.com/r/rybalka1/nginx-php>
- <https://hub.docker.com/r/rybalka1/php-fpm>
