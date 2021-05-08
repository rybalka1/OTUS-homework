## 2020-08-04

- Fix variable names in `./docker/context/conf.d/default.conf.tmpl`
- Update image version to `1.0.1`
- Optimize `./docker/context/Dockerfile`. Update image version to `1.0.2`
- Update `./docker/context/conf.d/default.conf.tmpl`. Add location `/version` return `${IMAGE_TAG}` value. Set image version to `1.1.0`
- Add `./docker-compose` with configuration for docker-cpompose with nginx and php-fpm
- Fix errors in `./docker-compose/nginx/Dockerfile`. Add variable `NGINX_STATIC_ROOT` definition ^_^
- Fix error in `./docker-compose/nginx/templates/phpinfo.conf.template`. Fix `root` value for `location ~ \.php$`.
- Refactoring `./docker-compose/php-fpm/Dockerfile`. Improve readability.
- Fix `./docker-compose/.env.example`. Provide actual variables.
- Update documentation
  - `./docker-compose/README.md`
  - `./docker/README.md`
  - `./README.md`

## 2020-08-23

- Start the HomeWork
- Add `README.md`
- Answer the questions 2 and 3 in `README.md`
- Add `./docker` directory
- Create `./docker/context` directory with docker context including `Dockerfile`
- Create `./docker/docker-compose.yml` file to build image and run container
- Create `./docker/README.md` with instructions how to configure, build, run and clean.
- Move `./docker/context/site.conf.tmpl` to `./docker/context/conf.d/site.conf.tmpl`
- Copy `./docker/context/conf.d/` into docker container `/etc/nginx/conf.d/`
- Move `./docker/context/site-content/index.html` to `./docker/context/www/default/index.html`
- Rename `./docker/context/conf.d/site.conf.tmpl` to `./docker/context/conf.d/default.conf.tmpl`
- Update entrypoint. Use `envsupst` for all config templates in `./docker/context/conf.d/*.tmpl`/ Rename templates to corresponding `.conf` files
- Rename variables:
  - `NGINX_SITE_PORT` to `NGINX_DEFAULT_SITE_PORT`
  - `NGINX_SITE_ROOT` to `NGINX_STATIC_ROOT`
  - `IMAGE_VERSION` to `IMAGE_TAG`
- Update image name and tag in `./docker/.env`
  ```shell
  IMAGE_NAME=vscoder/nginx
  IMAGE_TAG=1.0.0
  ```
- Publish image to docker hub
- Update `./README.dm`. Add task with an asterisk.
