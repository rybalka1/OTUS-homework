ansible-role-nginx
=========

Install nginx and create virtualhost
Role correct works with SELinux in `enforcement` mode!

Requirements
------------

none

Role Variables
--------------

See [defaults/main.yml](./defaults/main.yml)

Note: in `vars/` are placed platform-specific variables. Do not override by hands.

Dependencies
------------

None

Example Playbook
----------------

```
- name: Install and configure nginx
  hosts: all
  vars:
    nginx_version: 1.19.1
    nginx_site_name: example.net
    nginx_site_listen: 8081
  roles:
    - ansible-role-nginx
```

License
-------

BSD

Author Information
------------------

Koloskov Aleksey
