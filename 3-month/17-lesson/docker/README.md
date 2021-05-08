# nginx

Here is a docker container with nginx inside

## How to configure

Copy `.env.example` file to `.env` and update variables:
- container environment variables:
  - `NGINX_DEFAULT_SITE_PORT` port to nginx container listen to (`listen` directive value)
  - `NGINX_STATIC_ROOT` root directory for nginx sites (`root` directive value)
- compose-related variables
  - `IMAGE_NAME` docker image name
  - `IMAGE_VERSION` docker image tag

There is two directories:
- The 1st is `./context/conf.d`. Content of this directory will be placed to `/etc/nginx/conf.d`
- The 2nd is `./context/www`. Content of this directory will be placed to `${NGINX_STATIC_ROOT}` directory

To create static site:
1. Create static site config in `./context/conf.d` with extension `.tmpl`. It's possible to use variables described above.
2. Set static site root to `${NGINX_SITE_ROOT}/static_site_name`
3. Place static site content to `./context/www/static_site_name`

## How to run

Build image
```shell
docker-compose build
```

Run container
```shell
docker-compose up -d
```

Check
```shell
curl 127.0.0.1:8080/index.html
```

Stop container
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
...

Successfully built 6e91b733021e
Successfully tagged vscoder/nginx:1.0.0
```

Publish nginx image
```shell
docker-compose push
```
```log
Pushing nginx (vscoder/nginx:1.0.0)...
The push refers to repository [docker.io/vscoder/nginx]
749dcda0e522: Pushed
7441be22a4b5: Pushed
dc511cbb5964: Pushed
b8d208a2f21e: Pushed
e921a8b0641d: Pushed
06571e93d764: Pushed
50644c29ef5a: Pushed
1.0.0: digest: sha256:9b8ee500c5f403b9c7c47b47ff3350541d0bfe2d5e6b6aa7ccb550e4ebae18e6 size: 1774
```

https://hub.docker.com/r/vscoder/nginx
