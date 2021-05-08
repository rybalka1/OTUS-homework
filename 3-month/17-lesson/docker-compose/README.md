# nginx with php-fpm

Here is a docker compose with nginx and php-fpm services

## How to configure

Copy `.env.example` file to `.env` and update variables:
- container environment variables:
  - `NGINX_STATIC_ROOT` directory in nginx container with static content
  - `NGINX_DEFAULT_SITE_PORT` port to nginx container listen to (`listen` directive value)
- compose-related variables
  - `NGINX_IMAGE_NAME` nginx docker image name
  - `NGINX_IMAGE_TAG` nginx docker image tag
  - `PHP_IMAGE_NAME` php-fpm docker image name
  - `PHP_IMAGE_TAG` php-fpm docker image name

This task implementation has the next directory structure:
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

- `docker-compose.yml`: compose file
- `nginx`: docker context for nginx service
- `nginx/templates`: directory for nginx config templates (substracted with environment variables values). All templates must have suffix `.template`
- `nginx/www`: directory for nginx static html files
- `php-fpm`: docker context for php-fpm service
- `php-fpm/www`: directory for dynamic php content

## How to run

Build image
```shell
docker-compose build
```

Run compose
```shell
docker-compose up -d
```

Check
```shell
curl 127.0.0.1:8080/phpinfo.php
```
or open in browser http://127.0.0.1:8080/phpinfo.php

Stop compose
```shell
docker-compose down
```

## How to publish

Login to docker hub (accaunt must exists)
```shell
docker login
```

Build an image
```shell
docker-compose build
```
```log
Building nginx
Step 1/7 : FROM nginx:1.18.0-alpine
 ---> 8c1bfa967ebf
Step 2/7 : LABEL maintainer="Aleksey Koloskov <vsyscoder@gmail.com>"
 ---> Using cache
 ---> ca6ce2892bb5
Step 3/7 : ENV NGINX_STATIC_ROOT=/data/www
 ---> Using cache
 ---> 3df3dd395d60
Step 4/7 : WORKDIR ${NGINX_STATIC_ROOT}
 ---> Using cache
 ---> 067714e5b6b3
Step 5/7 : RUN rm /etc/nginx/conf.d/default.conf
 ---> Using cache
 ---> 406061e43cfa
Step 6/7 : COPY templates /etc/nginx/templates
 ---> Using cache
 ---> 0b5d0c24ac87
Step 7/7 : COPY www ${NGINX_STATIC_ROOT}
 ---> Using cache
 ---> 9e28286ca98d

Successfully built 9e28286ca98d
Successfully tagged vscoder/nginx-php:1.0.0
Building php-fpm
Step 1/4 : FROM php:7.4.9-fpm-alpine3.12
 ---> f9f075c5a926
Step 2/4 : LABEL maintainer="Aleksey Koloskov <vsyscoder@gmail.com>"
 ---> Using cache
 ---> 402f5989265a
Step 3/4 : COPY www /var/www/html
 ---> Using cache
 ---> 593ab6e2ced4
Step 4/4 : WORKDIR /var/www/html
 ---> Using cache
 ---> a12b109d3e9a

Successfully built a12b109d3e9a
Successfully tagged vscoder/php-fpm:1.0.0
```

Publish nginx image
```shell
docker-compose push
```
```log
Pushing nginx (vscoder/nginx-php:1.0.0)...
The push refers to repository [docker.io/vscoder/nginx-php]
2b29c204086d: Pushed2a0b9578a3b6: Pushed88de5337d8de: Pushed
057cebcbe53c: Pushed
37ea6c8b75fa: Mounted from library/nginx
14f687b6870a: Mounted from library/nginx
a638f39e4bbd: Mounted from library/nginx
4f8672401053: Mounted from library/nginx
3e207b409db3: Mounted from library/nginx
1.0.0: digest: sha256:3f240b23d6b5bdd948ec8c07df0a4cff8f6b1c90b571571575f0a003850b86fa size: 2188
Pushing php-fpm (vscoder/php-fpm:1.0.0)...
The push refers to repository [docker.io/vscoder/php-fpm]
0e6501fd3519: Pushed424670d9a7c5: Mounted from library/php
5efe40cdbc78: Mounted from library/php
a741fff4cdfc: Mounted from library/php
44cd3f68f8b1: Mounted from library/php
5b139208dd54: Mounted from library/php
76e7b3bdfbef: Mounted from library/php
81c338ff74a3: Mounted from library/php
308ef7bef157: Mounted from library/php
d94df04fea90: Mounted from library/php
50644c29ef5a: Mounted from vscoder/nginx
1.0.0: digest: sha256:d75058f2188f5f26c26f494fbd1105ebd4f601c9fe4415d3317c15b180e26ec3 size: 2618
```

- https://hub.docker.com/r/vscoder/nginx-php
- https://hub.docker.com/r/vscoder/php-fpm
