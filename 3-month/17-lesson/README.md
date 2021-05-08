# HomeWork 14: docker

## Tasks

- Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx)
- Определите разницу между контейнером и образом
- Вывод опишите в домашнем задании.
- Ответьте на вопрос: Можно ли в контейнере собрать ядро?
- Собранный образ необходимо запушить в docker hub и дать ссылку на ваш репозиторий.

---

1. Create custom alpen-based docker image with nginx. It must return custom web page after start (it's enought to change default nginx's page)
2. Define the difference between **docker container** and **docker image**. Describe conclusion in a HomeWork
3. Answer the question: is it possible to build kernel in a docker container?
4. Publish custom nginx docker image to [DockerHub](http://hub.docker.com)

---

Задание со * (звездочкой)
- Создайте кастомные образы nginx и php, объедините их в docker-compose.
- После запуска nginx должен показывать php info.
- Все собранные образы должны быть в docker hub

---

The task with * (an asterisk):
1. Create custom images with nginx and php. Combine them in single docker-compose environment
2. Nginx must show `php_info();` result
3. All images must be in docker hub

## Implementation

First let's answer to the questions:

### Answers to the questions

2. Define the difference between **docker container** and **docker image**.

**Docker image** is a base for a **docker container**. When you run docker container, docker gets an image and then creates new read/write filesystem layer based on it. Image is just definition which file structure has container on start and which commands container runs when it starts. Image is like a distribution of some software, and container is like an installed and started instance of these software.

I understand it like a _class_ and an _instance_ of a class in Object-Oriented Programming concept where instance inherits from a class object-structure but has it's own namespace.

---

3. Answer the question: is it possible to build kernel in a docker container?

Yes, it is possible! ^_^

But when building process finishes we got only builded kernel files as an artifact and nothing more. It's because docker container uses the kernel of host OS. Docker container just use possibilities of host's kernel like namespaces, cgroups, specisl filesystem, etcetera...

But if we don't want to install build environment in host OS, it's possible to use docker image with such environment to build kernel. Then the new kernel must be installed in **host's** OS. And we got repetitive environment for kernel build as a bonus.

### Build and publish nginx image

[NGINX](./docker/README.md)

#### How to check

Up and Check
```shell
cd ./docker
# Up docker-compose environment
docker-compose up -d
# Get static site content
curl 127.0.0.1:8080/index.html
```
```log
It's a default static site ^_^
```

Clean
```shell
docker-compose down
```

### Nginx and php-fpm

[NGINX-PHP](./docker-compose/README.md)

#### How to check

Up and Check
```shell
cd ./docker-compose
# Up docker-compose environment
docker-compose up -d
# Get static site content
curl 127.0.0.1:8080/phpinfo.php
```
```log
Huge output here. It's better to open in browser http://127.0.0.1:8080/phpinfo.php
```

Clean
```shell
docker-compose down
```
