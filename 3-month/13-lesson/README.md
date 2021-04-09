# Домашнее задание №13

## SELinux - когда все запрещено

**Цель**:  
Тренируем умение работать с SELinux: диагностировать проблемы и модифицировать политики SELinux для корректной работы приложений, если это требуется.

*1*. Запустить nginx на нестандартном порту 3-мя разными способами:

- переключатели setsebool;
- добавление нестандартного порта в имеющийся тип;
- формирование и установка модуля SELinux.
- README с описанием каждого решения (скриншоты и демонстрация приветствуются).

*2*. Обеспечить работоспособность приложения при включенном selinux.

- Развернуть приложенный стенд
<https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems>
- Выяснить причину неработоспособности механизма обновления зоны (см. README);
- Предложить решение (или решения) для данной проблемы;
- Выбрать одно из решений для реализации, предварительно обосновав выбор;
- Реализовать выбранное решение и продемонстрировать его работоспособность.
- README с анализом причины неработоспособности, возможными способами решения и обоснованием выбора одного из них;
- Исправленный стенд или демонстрация работоспособной системы скриншотами и описанием.  
Критерии оценки:  
Статус  **"Принято"** ставится при выполнении следующих условий:

- для задания 1 описаны, реализованы и продемонстрированы все 3 способа решения;
- для задания 2 описана причина неработоспособности механизма обновления зоны;
для задания 2 реализован и продемонстрирован один из способов решения;
Опционально для выполнения:

для задания 2 предложено более одного способа решения;
для задания 2 обоснованно(!) выбран один из способов решения.

### Что использовать для выполнения ДЗ

Пакет `setools-console`:  

- `sesearch`  
- `seinfo`
- `findcon`
- `getsebool`
- `setsebool`  

Пакет `policycoreutils-python`:  

- `audit2allow`
- `audit2why`  
Пакет `policycoreutils-newrole`:  

- `newrole`  

Пакет `selinux-policy-mls`:  

- `selinux-policy-mls`  

Пакет `setroubleshoot-server`:  

- `sealert`

### Задание 1: nginx

[NGINX.md](./NGINX.md)

#### Тесты

Проверяем, чтобы в файле  `./roles/ansible-role-nginx/molecule/default/converge.yml` параметр `nginx_selinux_seport` был устанавлен в значение `yes`.

- `nginx_selinux_seport` - разрешить nginx подключаться к сетевому порту, используя:

  ```shell
  semanage port -a -t http_port_t -p tcp 8085
  ```

Проверяем, чтобы второй параметр `nginx_selinux_sebool` был установлен  в значение `no`

- `nginx_selinux_sebool` - используем seboolean, чтобы разрешить nginx связываться с портом 8085:

  ```shell
  setsebool -P nis_enabled 1
  ```

Запускаем команду `make venv`

```shell
❯ make venv
test -d ./.venv || python3 -m venv ./.venv
./.venv/bin/pip install -r requirements.txt
Collecting ansible==2.9.10
  Using cached ansible-2.9.10.tar.gz (14.2 MB)
Collecting molecule==3.0.5
  Using cached molecule-3.0.5-py2.py3-none-any.whl (286 kB)
Collecting molecule-vagrant==0.3
  Downloading molecule_vagrant-0.3-py2.py3-none-any.whl (24 kB)
Collecting testinfra==5.2.2
  Using cached testinfra-5.2.2-py3-none-any.whl (69 kB)
Collecting PyYAML
  Using cached PyYAML-5.4.1-cp38-cp38-manylinux1_x86_64.whl (662 kB)
Collecting cryptography
  Using cached cryptography-3.4.7-cp36-abi3-manylinux2014_x86_64.whl (3.2 MB)
Collecting jinja2
  Using cached Jinja2-2.11.3-py2.py3-none-any.whl (125 kB)
Collecting tree-format>=0.1.2
  Using cached tree-format-0.1.2.tar.gz (4.0 kB)
Collecting yamllint<2,>=1.15.0
  Downloading yamllint-1.26.1.tar.gz (126 kB)
     |████████████████████████████████| 126 kB 4.8 MB/s 
Collecting click-help-colors>=0.6
  Using cached click_help_colors-0.9-py3-none-any.whl (5.3 kB)
Collecting python-gilt<2,>=1.2.1
  Using cached python_gilt-1.2.3-py2.py3-none-any.whl (22 kB)
Collecting paramiko<3,>=2.5.0
  Using cached paramiko-2.7.2-py2.py3-none-any.whl (206 kB)
Collecting pexpect<5,>=4.6.0
  Using cached pexpect-4.8.0-py2.py3-none-any.whl (59 kB)
Collecting cookiecutter!=1.7.1,>=1.6.0
  Using cached cookiecutter-1.7.2-py2.py3-none-any.whl (34 kB)
Collecting cerberus>=1.3.1
  Using cached Cerberus-1.3.2.tar.gz (52 kB)
Collecting tabulate>=0.8.4
  Using cached tabulate-0.8.9-py3-none-any.whl (25 kB)
Collecting selinux; sys_platform == "linux"
  Using cached selinux-0.2.1-py2.py3-none-any.whl (4.3 kB)
Collecting pluggy<1.0,>=0.7.1
  Using cached pluggy-0.13.1-py2.py3-none-any.whl (18 kB)
Collecting click>=7.0
  Using cached click-7.1.2-py2.py3-none-any.whl (82 kB)
Collecting sh<1.14,>=1.13.1
  Using cached sh-1.13.1-py2.py3-none-any.whl (40 kB)
Collecting click-completion>=0.5.1
  Using cached click-completion-0.5.2.tar.gz (10 kB)
Collecting colorama>=0.3.9
  Using cached colorama-0.4.4-py2.py3-none-any.whl (16 kB)
Collecting python-vagrant
  Downloading python-vagrant-0.5.15.tar.gz (29 kB)
Collecting pytest!=3.0.2
  Downloading pytest-6.2.3-py3-none-any.whl (280 kB)
     |████████████████████████████████| 280 kB 6.1 MB/s 
Collecting cffi>=1.12
  Using cached cffi-1.14.5-cp38-cp38-manylinux1_x86_64.whl (411 kB)
Collecting MarkupSafe>=0.23
  Using cached MarkupSafe-1.1.1-cp38-cp38-manylinux2010_x86_64.whl (32 kB)
Collecting pathspec>=0.5.3
  Using cached pathspec-0.8.1-py2.py3-none-any.whl (28 kB)
Collecting fasteners
  Using cached fasteners-0.16-py2.py3-none-any.whl (28 kB)
Collecting bcrypt>=3.1.3
  Using cached bcrypt-3.2.0-cp36-abi3-manylinux2010_x86_64.whl (63 kB)
Collecting pynacl>=1.0.1
  Using cached PyNaCl-1.4.0-cp35-abi3-manylinux1_x86_64.whl (961 kB)
Collecting ptyprocess>=0.5
  Using cached ptyprocess-0.7.0-py2.py3-none-any.whl (13 kB)
Collecting poyo>=0.5.0
  Using cached poyo-0.5.0-py2.py3-none-any.whl (10 kB)
Collecting python-slugify>=4.0.0
  Using cached python-slugify-4.0.1.tar.gz (11 kB)
Collecting requests>=2.23.0
  Using cached requests-2.25.1-py2.py3-none-any.whl (61 kB)
Collecting binaryornot>=0.4.4
  Using cached binaryornot-0.4.4-py2.py3-none-any.whl (9.0 kB)
Collecting six>=1.10
  Using cached six-1.15.0-py2.py3-none-any.whl (10 kB)
Collecting jinja2-time>=0.2.0
  Using cached jinja2_time-0.2.0-py2.py3-none-any.whl (6.4 kB)
Requirement already satisfied: setuptools in ./.venv/lib/python3.8/site-packages (from cerberus>=1.3.1->molecule==3.0.5->-r requirements.txt (line 2)) (44.0.0)
Collecting distro>=1.3.0
  Using cached distro-1.5.0-py2.py3-none-any.whl (18 kB)
Collecting shellingham
  Using cached shellingham-1.4.0-py2.py3-none-any.whl (9.4 kB)
Collecting py>=1.8.2
  Using cached py-1.10.0-py2.py3-none-any.whl (97 kB)
Collecting packaging
  Using cached packaging-20.9-py2.py3-none-any.whl (40 kB)
Collecting iniconfig
  Using cached iniconfig-1.1.1-py2.py3-none-any.whl (5.0 kB)
Collecting toml
  Using cached toml-0.10.2-py2.py3-none-any.whl (16 kB)
Collecting attrs>=19.2.0
  Using cached attrs-20.3.0-py2.py3-none-any.whl (49 kB)
Collecting pycparser
  Using cached pycparser-2.20-py2.py3-none-any.whl (112 kB)
Collecting text-unidecode>=1.3
  Using cached text_unidecode-1.3-py2.py3-none-any.whl (78 kB)
Collecting idna<3,>=2.5
  Using cached idna-2.10-py2.py3-none-any.whl (58 kB)
Collecting certifi>=2017.4.17
  Using cached certifi-2020.12.5-py2.py3-none-any.whl (147 kB)
Collecting urllib3<1.27,>=1.21.1
  Using cached urllib3-1.26.4-py2.py3-none-any.whl (153 kB)
Collecting chardet<5,>=3.0.2
  Using cached chardet-4.0.0-py2.py3-none-any.whl (178 kB)
Collecting arrow
  Using cached arrow-1.0.3-py3-none-any.whl (54 kB)
Collecting pyparsing>=2.0.2
  Using cached pyparsing-2.4.7-py2.py3-none-any.whl (67 kB)
Collecting python-dateutil>=2.7.0
  Using cached python_dateutil-2.8.1-py2.py3-none-any.whl (227 kB)
Using legacy setup.py install for ansible, since package 'wheel' is not installed.
Using legacy setup.py install for tree-format, since package 'wheel' is not installed.
Using legacy setup.py install for yamllint, since package 'wheel' is not installed.
Using legacy setup.py install for cerberus, since package 'wheel' is not installed.
Using legacy setup.py install for click-completion, since package 'wheel' is not installed.
Using legacy setup.py install for python-vagrant, since package 'wheel' is not installed.
Using legacy setup.py install for python-slugify, since package 'wheel' is not installed.
Installing collected packages: PyYAML, pycparser, cffi, cryptography, MarkupSafe, jinja2, ansible, tree-format, pathspec, yamllint, click, click-help-colors, six, fasteners, colorama, sh, python-gilt, bcrypt, pynacl, paramiko, ptyprocess, pexpect, poyo, text-unidecode, python-slugify, idna, certifi, urllib3, chardet, requests, binaryornot, python-dateutil, arrow, jinja2-time, cookiecutter, cerberus, tabulate, distro, selinux, pluggy, shellingham, click-completion, molecule, python-vagrant, molecule-vagrant, py, pyparsing, packaging, iniconfig, toml, attrs, pytest, testinfra
    Running setup.py install for ansible ... done
    Running setup.py install for tree-format ... done
    Running setup.py install for yamllint ... done
    Running setup.py install for python-slugify ... done
    Running setup.py install for cerberus ... done
    Running setup.py install for click-completion ... done
    Running setup.py install for python-vagrant ... done
Successfully installed MarkupSafe-1.1.1 PyYAML-5.4.1 ansible-2.9.10 arrow-1.0.3 attrs-20.3.0 bcrypt-3.2.0 binaryornot-0.4.4 cerberus-1.3.2 certifi-2020.12.5 cffi-1.14.5 chardet-4.0.0 click-7.1.2 click-completion-0.5.2 click-help-colors-0.9 colorama-0.4.4 cookiecutter-1.7.2 cryptography-3.4.7 distro-1.5.0 fasteners-0.16 idna-2.10 iniconfig-1.1.1 jinja2-2.11.3 jinja2-time-0.2.0 molecule-3.0.5 molecule-vagrant-0.3 packaging-20.9 paramiko-2.7.2 pathspec-0.8.1 pexpect-4.8.0 pluggy-0.13.1 poyo-0.5.0 ptyprocess-0.7.0 py-1.10.0 pycparser-2.20 pynacl-1.4.0 pyparsing-2.4.7 pytest-6.2.3 python-dateutil-2.8.1 python-gilt-1.2.3 python-slugify-4.0.1 python-vagrant-0.5.15 requests-2.25.1 selinux-0.2.1 sh-1.13.1 shellingham-1.4.0 six-1.15.0 tabulate-0.8.9 testinfra-5.2.2 text-unidecode-1.3 toml-0.10.2 tree-format-0.1.2 urllib3-1.26.4 yamllint-1.26.1
To activate venv, run:
source .venv/bin/activate
```

Make-file сообщает, что необходимо активировать виртуальное окружение Python, активируем:

```bash
source .venv/bin/activate
```

Затем запускаем `make nginx-test`, если всё отрабатывается без ошибок, то увидим примерно следующее:

```shell
TASK [Ensure nginx works] ******************************************************
    ok: [centos-7] => (item=8082)
    ok: [vscoder-centos-7-5] => (item=8082)
    ok: [centos-8] => (item=8082)
    ok: [centos-7] => (item=8083)
    ok: [centos-8] => (item=8083)
    ok: [vscoder-centos-7-5] => (item=8083)
    ok: [vscoder-centos-7-5] => (item=8084)
    ok: [centos-7] => (item=8084)
    ok: [centos-8] => (item=8084)
```

nginx работает на указанных портах.

## Задание 2: SELinux: проблема с удаленным обновлением зоны DNS

[SELINUX_DNS_PROBLEMS.md](./SELINUX_DNS_PROBLEMS.md)

## Как проверяем

Если не деактивировали vev просто запускаем команду ниже. Если виртуальное окружение деактивировано, то сначала активируем его (source .venv/bin/activate)  
Далее запускае

```shell
make dns-test
```

Ждём несколько минут...

```log
TASK [Check output] ************************************************************
ok: [client] => {
    "msg": "nsupdate.rc: 0\nnsupdate.stdout: \nnsupdate.stderr: \n"
}

TASK [Lookup www.ddns.lab.] ****************************************************
changed: [client]

TASK [Lookup result] ***********************************************************
ok: [client] => {
    "msg": "dig.rc: 0\ndig.stdout: \n; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el7_9.4 <<>> www.ddns.lab. @192.168.50.10\n;; global options: +cmd\n;; Got answer:\n;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 45831\n;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2\n\n;; OPT PSEUDOSECTION:\n; EDNS: version: 0, flags:; udp: 4096\n;; QUESTION SECTION:\n;www.ddns.lab.\t\t\tIN\tA\n\n;; ANSWER SECTION:\nwww.ddns.lab.\t\t60\tIN\tA\t192.168.50.15\n\n;; AUTHORITY SECTION:\nddns.lab.\t\t3600\tIN\tNS\tns01.dns.lab.\n\n;; ADDITIONAL SECTION:\nns01.dns.lab.\t\t3600\tIN\tA\t192.168.50.10\n\n;; Query time: 0 msec\n;; SERVER: 192.168.50.10#53(192.168.50.10)\n;; WHEN: Thu Apr 08 20:02:40 UTC 2021\n;; MSG SIZE  rcvd: 96\ndig.stderr: \n"
}
```

По выводу видно, что всё в порядке.

Вывод задачи `TASK [Lookup result]` в более читаемом виде:

```log
dig.rc: 0
dig.stdout: 
; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el7_9.4 <<>> www.ddns.lab. @192.168.50.10
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 45831
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.ddns.lab.   IN A

;; ANSWER SECTION:
www.ddns.lab.  60 IN A 192.168.50.15

;; AUTHORITY SECTION:
ddns.lab.  3600 IN NS ns01.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.  3600 IN A 192.168.50.10

;; Query time: 0 msec
;; SERVER: 192.168.50.10#53(192.168.50.10)
;; WHEN: Thu Apr 08 20:02:40 UTC 2021
;; MSG SIZE  rcvd: 96
dig.stderr:  
```

## Очистка тестового стенда

Чтобы почистить тестовый стенд запускаем:

```shell
make clean
```

Удаляем каталог вм=иртуального окружения Python:

```shell
deactivate
rm -rf .venv
```
