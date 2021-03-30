# ansible-role-nginx

Установка nginx и создание аиртуального хоста

## Переменные используемые ролью

Тут --> [defaults/main.yml](./defaults/main.yml)

>Примечание: в `vars/` помещаются переменные, зависящие от платформы. Не вводить руками.

## Пример использования playbook

```yaml
- name: Install and configure nginx
  hosts: all
  vars:
    nginx_version: 1.19.1
    nginx_site_name: example.net
    nginx_site_listen: 8081
  roles:
    - ansible-role-nginx
```
