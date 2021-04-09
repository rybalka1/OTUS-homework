## 2020-08-30

- Add [The second way](./SELINUX_DNS_PROBLEMS.md#the-second-way) for `Task 2*`
- Fix `./roles/ansible-role-selinux/README.md`

## 2020-08-21

- Add `./selinux_dns_problems/provisioning/selinux.yml`. Fix selinux fcontext for `/etc/named/dynamic`
- Add more tests in `./selinux_dns_problems/provisioning/test.yml`
- Rename `./roles/ansible-role-nginx/molecule/vagrant-8085` to `./roles/ansible-role-nginx/molecule/default`
- Fix tests in `./roles/ansible-role-nginx/molecule/default/tests/test_default.py`
- Update `Makefile`
- Update documentation

## 2020-08-20

- Add example environment for the Task 2
  - `./selinux_dns_problems`
- Add `./SELINUX_DNS_PROBLEMS.md` with:
  - The Task
  - The Goal
  - The Analyse

## 2020-08-17

- Add selinux type configuration
- Add selinux boolean configuration
- README refactoring
- package `setroubleshoot-server` removed from `HW13-selinux/roles/ansible-role-selinux/vars/CentOS-7.yml` because of standard centos 7 box is hangs when reboot if package was installed

## 2020-08-14

- Create molecule scenario `vagrant-8085` from scenario `default`. Set nginx listen port 8085 which has context `system_u:object_r:unreserved_port_t:s0`

## 2020-08-12

- Generate selinux policy module

## 2020-08-10

- Add role `ansible-role-selinux` to enable selinux and install management and diagnostic utilites
- Apply role `ansible-role-selinux` before configure nginx with `roles/ansible-role-nginx/molecule/default/converge.yml`
- Set for nginx listen port `8080` and pass them with molecule vagrant platforms
- Enable seboolean flag `httpd_can_network_connect` with ansible-role-nginx
- Add handler `Restart nginx` in `roles/ansible-role-nginx/handlers/main.yml`

## 2020-08-07

- Update `molecule/default/molecule.yml` expose nginx ports
- Update `molecule/default/converge.yml` set values for
  - `nginx_selinux_mode`
  - `nginx_site_listen`
  - Add `post_tasks` with nginx availability checks

## 2020-08-06

- Update `./roles/ansible-role-nginx/tasks/selinux.yml`. Add selinux policy and mode configuration.
- Rename `./roles/ansible-role-nginx/molecule/deocker-testinfra` to `./roles/ansible-role-nginx/molecule/docker-testinfra`
- Add tests to `./roles/ansible-role-nginx/molecule/default/tests/test_default.py`

## 2020-08-04

- Start HW
- Create `README.md`, `Makefile`, `requirements.txt`, `Vagrantfile`
- Add [Makefile](./Makefile) targets
  - `create:`
  - `converge:`
  - `verify:`
  - `destroy:`
  - `test:`
  - `clean: destroy`

- Rename instance name in `Vagrantfile`
- Create `provision/` with samble provisioning bash script
- Copy `roles/ansible-role-nginx` from _HW11-ansible_
- Rename molecule scenario `default` to `docker-testinfra`
- Create molecule scenrio `default` with driver `vagrant` and verifier `testinfra`
  ```shell
  molecule init scenario --driver-name vagrant --role-name ansible-role-nginx --verifier-name testinfra vagrant-testinfra
  ```
- Update `HW13-selinux/roles/ansible-role-nginx/molecule/default/molecule.yml` set instances list to
  - vscoder/centos-7-5
  - centos/7
  - centos/8
