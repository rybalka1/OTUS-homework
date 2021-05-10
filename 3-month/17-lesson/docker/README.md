# nginx

Создаём докер-контейнер с nginx

## Конфигурируем окружение

Заходим в директорию 17-lesson/docker
Копируем файл примера `.env.example` в рабочий `.env` и записываем свои значения в переменные окружения:

- переменные среды контейнера:
  - `NGINX_DEFAULT_SITE_PORT` порт в контейнере который слушает nginx(`listen` значение дерективы)
  - `NGINX_STATIC_ROOT` root дериктория для сайта nginx sites (`root` значение дерективы)
- переменные compose-related
  - `IMAGE_NAME` имя докер имиджа
  - `IMAGE_VERSION` тег докер имиджа

Имеем два каталога:

- Первый `./context/conf.d`. Содержимое этого каталога будет помещено в `/etc/nginx/conf.d`

- Второй `./context/www`. Содержимое этого каталога будет помещено в `${NGINX_STATIC_ROOT}` directory

Создаём статический сайт:

1. Создаём статическую конфигурацию сайта в `./context/conf.d` с расширением `.tmpl`. Возможно использование переменных, описанных выше.
2. Устанавливаем статический корень сайта на `${NGINX_SITE_ROOT}/static_site_name`
3. Поместим статический контент сайта в `./context/www/static_site_name`

## Запуск тестового окружения

Собираем образ

```shell
docker-compose build
```

Этот пунк те обязательный, нужен только если используется VPN или уже используется такой диапазон IP:

```shell
docker network create my-network --subnet 172.24.24.0/24
```

Запускаем контейнер:

```shell
docker-compose up -d
```

Проверяем, что контейнер с nginx работает:

```shell
curl 127.0.0.1:8080/index.html
```

Останавливаем контейнер:

```shell
docker-compose down
```

## Публикация своего образа в Docker Hub

Войдиv в Docker Hub (аккаунт должен существовать)

```shell
docker login
```

Собираем образ:

```shell
docker-compose build
```

```log
Building nginx
Sending build context to Docker daemon  7.168kB
Step 1/15 : FROM alpine:3.12.0
 ---> a24bb4013296
Step 2/15 : LABEL maintainer="Dmitry Rybalka <rybalka.dmitrii@gmail.com>"
 ---> Using cache
 ---> 5be9cf10a24d
Step 3/15 : ARG NGINX_VERSION=1.18.0-r0
 ---> Using cache
 ---> 72f00f8c99f4
Step 4/15 : ARG GETTEXT_VERSION=0.20.2-r0
 ---> Using cache
 ---> f866a5155042
Step 5/15 : ENV NGINX_DEFAULT_SITE_PORT=8080
 ---> Using cache
 ---> 9612e7d0ff6d
Step 6/15 : ENV NGINX_STATIC_ROOT=/data/www
 ---> Using cache
 ---> e0d7683a5e62
Step 7/15 : RUN apk update &&     apk add --no-cache     gettext==${GETTEXT_VERSION}     nginx==${NGINX_VERSION}
 ---> Using cache
 ---> 52c69c1992d0
Step 8/15 : COPY entrypoint.sh /
 ---> Using cache
 ---> 1c9218ac7c25
Step 9/15 : RUN chmod +x /entrypoint.sh
 ---> Using cache
 ---> 404f3fb5c4a6
Step 10/15 : ENTRYPOINT ["/entrypoint.sh"]
 ---> Using cache
 ---> b9a55957daf6
Step 11/15 : COPY conf.d /etc/nginx/conf.d
 ---> Using cache
 ---> b503a05fcf64
Step 12/15 : RUN mkdir -p ${NGINX_STATIC_ROOT}
 ---> Using cache
 ---> 2ba7c5702a91
Step 13/15 : COPY www ${NGINX_STATIC_ROOT}
 ---> Using cache
 ---> 2b48db6e0ec3
Step 14/15 : EXPOSE ${NGINX_DEFAULT_SITE_PORT}
 ---> Using cache
 ---> a164faec9bac
Step 15/15 : CMD ["nginx", "-g", "daemon off;"]
 ---> Using cache
 ---> 3ea90eb8da35
Successfully built 3ea90eb8da35
Successfully tagged rybalka/nginx:1.1.0
```

Публикуем образ на Docker Hub:

```shell
docker-compose push
```

```log
Pushing nginx (rybalka1/nginx:1.1.0)...
The push refers to repository [docker.io/rybalka1/nginx]
6ec3033498ae: Pushed
2044dc29d1ed: Pushed
d11081e6b5ab: Pushed
295052945cf7: Pushed
011e1d7d8f88: Pushed
294c7101e4bf: Pushed
50644c29ef5a: Pushed
1.1.0: digest: sha256:65fcbd03bbc4cb7198dc507fc87bb6e5975478074cdf371bc57d65ac457a32c4 size: 1774
```

<https://hub.docker.com/r/rybalka1/nginx>
