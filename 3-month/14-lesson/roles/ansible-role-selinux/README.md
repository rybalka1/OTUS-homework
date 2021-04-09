ansible-role-selinux
=========

Set selinux mode and install selinux management and diagnostic utils

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

For diagnostics
```yaml
- name: Install and configure selinux for diagnostic
  hosts: all
  vars:
    selinux_mode: permissive
    selinux_reboot: yes
    selinux_utils: yes
  roles:
    - ansible-role-selinux
```

For prod
```yaml
- name: Install and configure selinux
  hosts: all
  vars:
    selinux_mode: enforcing
    # Reboot if selinux is disabled
    selinux_reboot: yes
    selinux_utils: no
  roles:
    - ansible-role-selinux
```

License
-------

BSD

Author Information
------------------

Koloskov Aleksey
