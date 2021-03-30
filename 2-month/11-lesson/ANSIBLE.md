# Ansible

Создаём виртуальное окружение, если не было создано ранее:

```shell
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

```log
Collecting ansible==2.9.10
  Downloading ansible-2.9.10.tar.gz (14.2 MB)
     |████████████████████████████████| 14.2 MB 2.0 MB/s 
Collecting molecule[docker]==3.0.5
  Downloading molecule-3.0.5-py2.py3-none-any.whl (286 kB)
     |████████████████████████████████| 286 kB 2.1 MB/s 
Collecting testinfra==5.2.2
  Downloading testinfra-5.2.2-py3-none-any.whl (69 kB)
     |████████████████████████████████| 69 kB 2.3 MB/s 
Collecting PyYAML
  Downloading PyYAML-5.4.1-cp38-cp38-manylinux1_x86_64.whl (662 kB)
     |████████████████████████████████| 662 kB 2.1 MB/s 
Collecting cryptography
  Downloading cryptography-3.4.7-cp36-abi3-manylinux2014_x86_64.whl (3.2 MB)
     |████████████████████████████████| 3.2 MB 2.7 MB/s 
Collecting jinja2
  Downloading Jinja2-2.11.3-py2.py3-none-any.whl (125 kB)
     |████████████████████████████████| 125 kB 2.8 MB/s 
Collecting cookiecutter!=1.7.1,>=1.6.0
  Downloading cookiecutter-1.7.2-py2.py3-none-any.whl (34 kB)
Collecting cerberus>=1.3.1
  Downloading Cerberus-1.3.2.tar.gz (52 kB)
     |████████████████████████████████| 52 kB 1.2 MB/s 
Collecting click>=7.0
  Downloading click-7.1.2-py2.py3-none-any.whl (82 kB)
     |████████████████████████████████| 82 kB 908 kB/s 
Collecting paramiko<3,>=2.5.0
  Using cached paramiko-2.7.2-py2.py3-none-any.whl (206 kB)
Collecting colorama>=0.3.9
  Downloading colorama-0.4.4-py2.py3-none-any.whl (16 kB)
Collecting sh<1.14,>=1.13.1
  Downloading sh-1.13.1-py2.py3-none-any.whl (40 kB)
     |████████████████████████████████| 40 kB 3.0 MB/s 
Collecting tree-format>=0.1.2
  Downloading tree-format-0.1.2.tar.gz (4.0 kB)
Collecting python-gilt<2,>=1.2.1
  Downloading python_gilt-1.2.3-py2.py3-none-any.whl (22 kB)
Collecting tabulate>=0.8.4
  Downloading tabulate-0.8.9-py3-none-any.whl (25 kB)
Collecting yamllint<2,>=1.15.0
  Downloading yamllint-1.26.0-py2.py3-none-any.whl (60 kB)
     |████████████████████████████████| 60 kB 2.6 MB/s 
Collecting selinux; sys_platform == "linux"
  Downloading selinux-0.2.1-py2.py3-none-any.whl (4.3 kB)
Collecting click-completion>=0.5.1
  Downloading click-completion-0.5.2.tar.gz (10 kB)
Collecting pexpect<5,>=4.6.0
  Using cached pexpect-4.8.0-py2.py3-none-any.whl (59 kB)
Collecting pluggy<1.0,>=0.7.1
  Using cached pluggy-0.13.1-py2.py3-none-any.whl (18 kB)
Collecting click-help-colors>=0.6
  Downloading click_help_colors-0.9-py3-none-any.whl (5.3 kB)
Collecting docker>=2.0.0; extra == "docker"
  Downloading docker-4.4.4-py2.py3-none-any.whl (147 kB)
     |████████████████████████████████| 147 kB 2.8 MB/s 
Collecting pytest!=3.0.2
  Using cached pytest-6.2.2-py3-none-any.whl (280 kB)
Collecting cffi>=1.12
  Downloading cffi-1.14.5-cp38-cp38-manylinux1_x86_64.whl (411 kB)
     |████████████████████████████████| 411 kB 3.1 MB/s 
Collecting MarkupSafe>=0.23
  Downloading MarkupSafe-1.1.1-cp38-cp38-manylinux2010_x86_64.whl (32 kB)
Collecting requests>=2.23.0
  Downloading requests-2.25.1-py2.py3-none-any.whl (61 kB)
     |████████████████████████████████| 61 kB 2.0 MB/s 
Collecting jinja2-time>=0.2.0
  Downloading jinja2_time-0.2.0-py2.py3-none-any.whl (6.4 kB)
Collecting six>=1.10
  Using cached six-1.15.0-py2.py3-none-any.whl (10 kB)
Collecting binaryornot>=0.4.4
  Downloading binaryornot-0.4.4-py2.py3-none-any.whl (9.0 kB)
Collecting poyo>=0.5.0
  Downloading poyo-0.5.0-py2.py3-none-any.whl (10 kB)
Collecting python-slugify>=4.0.0
  Downloading python-slugify-4.0.1.tar.gz (11 kB)
Requirement already satisfied: setuptools in ./.venv/lib/python3.8/site-packages (from cerberus>=1.3.1->molecule[docker]==3.0.5->-r requirements.txt (line 2)) (44.0.0)
Collecting pynacl>=1.0.1
  Using cached PyNaCl-1.4.0-cp35-abi3-manylinux1_x86_64.whl (961 kB)
Collecting bcrypt>=3.1.3
  Using cached bcrypt-3.2.0-cp36-abi3-manylinux2010_x86_64.whl (63 kB)
Collecting fasteners
  Downloading fasteners-0.16-py2.py3-none-any.whl (28 kB)
Collecting pathspec>=0.5.3
  Downloading pathspec-0.8.1-py2.py3-none-any.whl (28 kB)
Collecting distro>=1.3.0
  Downloading distro-1.5.0-py2.py3-none-any.whl (18 kB)
Collecting shellingham
  Downloading shellingham-1.4.0-py2.py3-none-any.whl (9.4 kB)
Collecting ptyprocess>=0.5
  Using cached ptyprocess-0.7.0-py2.py3-none-any.whl (13 kB)
Collecting websocket-client>=0.32.0
  Downloading websocket_client-0.58.0-py2.py3-none-any.whl (61 kB)
     |████████████████████████████████| 61 kB 2.2 MB/s 
Collecting packaging
  Using cached packaging-20.9-py2.py3-none-any.whl (40 kB)
Collecting iniconfig
  Using cached iniconfig-1.1.1-py2.py3-none-any.whl (5.0 kB)
Collecting py>=1.8.2
  Using cached py-1.10.0-py2.py3-none-any.whl (97 kB)
Collecting attrs>=19.2.0
  Using cached attrs-20.3.0-py2.py3-none-any.whl (49 kB)
Collecting toml
  Using cached toml-0.10.2-py2.py3-none-any.whl (16 kB)
Collecting pycparser
  Using cached pycparser-2.20-py2.py3-none-any.whl (112 kB)
Collecting certifi>=2017.4.17
  Downloading certifi-2020.12.5-py2.py3-none-any.whl (147 kB)
     |████████████████████████████████| 147 kB 2.1 MB/s 
Collecting chardet<5,>=3.0.2
  Downloading chardet-4.0.0-py2.py3-none-any.whl (178 kB)
     |████████████████████████████████| 178 kB 2.2 MB/s 
Collecting idna<3,>=2.5
  Downloading idna-2.10-py2.py3-none-any.whl (58 kB)
     |████████████████████████████████| 58 kB 2.2 MB/s 
Collecting urllib3<1.27,>=1.21.1
  Downloading urllib3-1.26.4-py2.py3-none-any.whl (153 kB)
     |████████████████████████████████| 153 kB 2.2 MB/s 
Collecting arrow
  Downloading arrow-1.0.3-py3-none-any.whl (54 kB)
     |████████████████████████████████| 54 kB 1.8 MB/s 
Collecting text-unidecode>=1.3
  Using cached text_unidecode-1.3-py2.py3-none-any.whl (78 kB)
Collecting pyparsing>=2.0.2
  Using cached pyparsing-2.4.7-py2.py3-none-any.whl (67 kB)
Collecting python-dateutil>=2.7.0
  Using cached python_dateutil-2.8.1-py2.py3-none-any.whl (227 kB)
Using legacy setup.py install for ansible, since package 'wheel' is not installed.
Using legacy setup.py install for cerberus, since package 'wheel' is not installed.
Using legacy setup.py install for tree-format, since package 'wheel' is not installed.
Using legacy setup.py install for click-completion, since package 'wheel' is not installed.
Using legacy setup.py install for python-slugify, since package 'wheel' is not installed.
Installing collected packages: PyYAML, pycparser, cffi, cryptography, MarkupSafe, jinja2, ansible, click, certifi, chardet, idna, urllib3, requests, six, python-dateutil, arrow, jinja2-time, binaryornot, poyo, text-unidecode, python-slugify, cookiecutter, cerberus, pynacl, bcrypt, paramiko, colorama, sh, tree-format, fasteners, python-gilt, tabulate, pathspec, yamllint, distro, selinux, shellingham, click-completion, ptyprocess, pexpect, pluggy, click-help-colors, websocket-client, docker, molecule, pyparsing, packaging, iniconfig, py, attrs, toml, pytest, testinfra
    Running setup.py install for ansible ... done
    Running setup.py install for python-slugify ... done
    Running setup.py install for cerberus ... done
    Running setup.py install for tree-format ... done
    Running setup.py install for click-completion ... done
Successfully installed MarkupSafe-1.1.1 PyYAML-5.4.1 ansible-2.9.10 arrow-1.0.3 attrs-20.3.0 bcrypt-3.2.0 binaryornot-0.4.4 cerberus-1.3.2 certifi-2020.12.5 cffi-1.14.5 chardet-4.0.0 click-7.1.2 click-completion-0.5.2 click-help-colors-0.9 colorama-0.4.4 cookiecutter-1.7.2 cryptography-3.4.7 distro-1.5.0 docker-4.4.4 fasteners-0.16 idna-2.10 iniconfig-1.1.1 jinja2-2.11.3 jinja2-time-0.2.0 molecule-3.0.5 packaging-20.9 paramiko-2.7.2 pathspec-0.8.1 pexpect-4.8.0 pluggy-0.13.1 poyo-0.5.0 ptyprocess-0.7.0 py-1.10.0 pycparser-2.20 pynacl-1.4.0 pyparsing-2.4.7 pytest-6.2.2 python-dateutil-2.8.1 python-gilt-1.2.3 python-slugify-4.0.1 requests-2.25.1 selinux-0.2.1 sh-1.13.1 shellingham-1.4.0 six-1.15.0 tabulate-0.8.9 testinfra-5.2.2 text-unidecode-1.3 toml-0.10.2 tree-format-0.1.2 urllib3-1.26.4 websocket-client-0.58.0 yamllint-1.26.0
```

## Тестирование

Заходим в директорию с ролью и запускаем тесты с molecule:

```shell
cd roles/ansible-role-nginx
molecule test
```

```log
--> Test matrix
    
└── default
    ├── dependency
    ├── lint
    ├── cleanup
    ├── destroy
    ├── syntax
    ├── create
    ├── prepare
    ├── converge
    ├── idempotence
    ├── side_effect
    ├── verify
    ├── cleanup
    └── destroy
    
--> Scenario: 'default'
--> Action: 'dependency'
Skipping, missing the requirements file.
Skipping, missing the requirements file.
--> Scenario: 'default'
--> Action: 'lint'
--> Lint is disabled.
--> Scenario: 'default'
--> Action: 'cleanup'
Skipping, cleanup playbook not configured.
--> Scenario: 'default'
--> Action: 'destroy'
--> Sanity checks: 'docker'
    
    PLAY [Destroy] *****************************************************************
    
    TASK [Destroy molecule instance(s)] ********************************************
    changed: [localhost] => (item=centos-8)
    changed: [localhost] => (item=centos-7)
    
    TASK [Wait for instance(s) deletion to complete] *******************************
    ok: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '181038782909.1270555', 'results_file': '/home/rybalka/.ansible_async/181038782909.1270555', 'changed': True, 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
    ok: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '64025079185.1270583', 'results_file': '/home/rybalka/.ansible_async/64025079185.1270583', 'changed': True, 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
    
    TASK [Delete docker network(s)] ************************************************
    
    PLAY RECAP *********************************************************************
    localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
    
--> Scenario: 'default'
--> Action: 'syntax'
    
    playbook: /home/rybalka/git-my-repo/OTUS-homework/2-month/11-lesson/roles/ansible-role-nginx/molecule/default/converge.yml
--> Scenario: 'default'
--> Action: 'create'
    
    PLAY [Create] ******************************************************************
    
    TASK [Log into a Docker registry] **********************************************
    skipping: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}) 
    skipping: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}) 
    
    TASK [Check presence of custom Dockerfiles] ************************************
    ok: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
    ok: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
    
    TASK [Create Dockerfiles from image names] *************************************
    changed: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
    changed: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
    
    TASK [Discover local Docker images] ********************************************
    ok: [localhost] => (item={'diff': [], 'dest': '/home/rybalka/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_8', 'src': '/home/rybalka/.ansible/tmp/ansible-tmp-1617099701.9442456-1270747-240381512773397/source', 'md5sum': '435ecceac31066c269a59c1eccf9c3a5', 'checksum': 'da2833c7bfbbf0c41991a97ecfbe2b5eac215b0d', 'changed': True, 'uid': 1000, 'gid': 1000, 'owner': 'rybalka', 'group': 'rybalka', 'mode': '0600', 'state': 'file', 'size': 996, 'invocation': {'module_args': {'src': '/home/rybalka/.ansible/tmp/ansible-tmp-1617099701.9442456-1270747-240381512773397/source', 'dest': '/home/rybalka/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_8', 'mode': None, 'follow': False, '_original_basename': 'Dockerfile.j2', 'checksum': 'da2833c7bfbbf0c41991a97ecfbe2b5eac215b0d', 'backup': False, 'force': True, 'content': None, 'validate': None, 'directory_mode': None, 'remote_src': None, 'local_follow': None, 'owner': None, 'group': None, 'seuser': None, 'serole': None, 'selevel': None, 'setype': None, 'attributes': None, 'regexp': None, 'delimiter': None, 'unsafe_writes': None}}, 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
    ok: [localhost] => (item={'diff': [], 'dest': '/home/rybalka/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_7', 'src': '/home/rybalka/.ansible/tmp/ansible-tmp-1617099702.3473535-1270747-130338467762045/source', 'md5sum': '81243f7200a1278e62fa0e3f89f54ef0', 'checksum': '1b69eccc2a49ad979c357f356233d42a8cdcaada', 'changed': True, 'uid': 1000, 'gid': 1000, 'owner': 'rybalka', 'group': 'rybalka', 'mode': '0600', 'state': 'file', 'size': 996, 'invocation': {'module_args': {'src': '/home/rybalka/.ansible/tmp/ansible-tmp-1617099702.3473535-1270747-130338467762045/source', 'dest': '/home/rybalka/.cache/molecule/ansible-role-nginx/default/Dockerfile_centos_7', 'mode': None, 'follow': False, '_original_basename': 'Dockerfile.j2', 'checksum': '1b69eccc2a49ad979c357f356233d42a8cdcaada', 'backup': False, 'force': True, 'content': None, 'validate': None, 'directory_mode': None, 'remote_src': None, 'local_follow': None, 'owner': None, 'group': None, 'seuser': None, 'serole': None, 'selevel': None, 'setype': None, 'attributes': None, 'regexp': None, 'delimiter': None, 'unsafe_writes': None}}, 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
    
    TASK [Build an Ansible compatible image (new)] *********************************
    changed: [localhost] => (item=molecule_local/centos:8)
    changed: [localhost] => (item=molecule_local/centos:7)
    
    TASK [Create docker network(s)] ************************************************
    
    TASK [Determine the CMD directives] ********************************************
    ok: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
    ok: [localhost] => (item={'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']})
    
    TASK [Create molecule instance(s)] *********************************************
    changed: [localhost] => (item=centos-8)
    changed: [localhost] => (item=centos-7)
    
    TASK [Wait for instance(s) creation to complete] *******************************
    FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
    changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '404775110052.1271834', 'results_file': '/home/rybalka/.ansible_async/404775110052.1271834', 'changed': True, 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
    changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '136509860779.1271861', 'results_file': '/home/rybalka/.ansible_async/136509860779.1271861', 'changed': True, 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
    
    PLAY RECAP *********************************************************************
    localhost                  : ok=7    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
    
--> Scenario: 'default'
--> Action: 'prepare'
Skipping, prepare playbook not configured.
--> Scenario: 'default'
--> Action: 'converge'
    
    PLAY [Converge] ****************************************************************
    
    TASK [Gathering Facts] *********************************************************
    ok: [centos-8]
    ok: [centos-7]
    
    TASK [Include ansible-role-nginx] **********************************************
    
    TASK [ansible-role-nginx : include_vars] ***************************************
    ok: [centos-7]
    ok: [centos-8]
    
    TASK [ansible-role-nginx : include_tasks] **************************************
    included: /home/rybalka/git-my-repo/OTUS-homework/2-month/11-lesson/roles/ansible-role-nginx/tasks/install_CentOS.yml for centos-8, centos-7
    
    TASK [ansible-role-nginx : Add repo] *******************************************
    changed: [centos-7]
    changed: [centos-8]
    
    TASK [ansible-role-nginx : Ensure openssl installed] ***************************
    changed: [centos-8]
    changed: [centos-7]
    
    TASK [ansible-role-nginx : Ensure nginx installed] *****************************
    changed: [centos-8]
    changed: [centos-7]
    
    TASK [ansible-role-nginx : include_tasks] **************************************
    included: /home/rybalka/git-my-repo/OTUS-homework/2-month/11-lesson/roles/ansible-role-nginx/tasks/configure.yml for centos-7, centos-8
    
    TASK [ansible-role-nginx : Provide nginx site config] **************************
    changed: [centos-7]
    changed: [centos-8]
    
    TASK [ansible-role-nginx : include_tasks] **************************************
    included: /home/rybalka/git-my-repo/OTUS-homework/2-month/11-lesson/roles/ansible-role-nginx/tasks/service.yml for centos-7, centos-8
    
    TASK [ansible-role-nginx : Enable and start service] ***************************
fatal: [centos-8]: FAILED! => {"changed": false, "msg": "Service is in unknown state", "status": {}}
    changed: [centos-7]
    
    RUNNING HANDLER [ansible-role-nginx : Reload nginx] ****************************
    included: /home/rybalka/git-my-repo/OTUS-homework/2-month/11-lesson/roles/ansible-role-nginx/tasks/reload_nginx.yml for centos-7
    
    RUNNING HANDLER [ansible-role-nginx : Check nginx config] **********************
    changed: [centos-7]
    
    RUNNING HANDLER [ansible-role-nginx : Reload nginx] ****************************
    changed: [centos-7]
    
    PLAY RECAP *********************************************************************
    centos-7                   : ok=13   changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    centos-8                   : ok=9    changed=4    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
    
ERROR: 
An error occurred during the test sequence action: 'converge'. Cleaning up.
--> Scenario: 'default'
--> Action: 'cleanup'
Skipping, cleanup playbook not configured.
--> Scenario: 'default'
--> Action: 'destroy'
    
    PLAY [Destroy] *****************************************************************
    
    TASK [Destroy molecule instance(s)] ********************************************
    changed: [localhost] => (item=centos-8)
    changed: [localhost] => (item=centos-7)
    
    TASK [Wait for instance(s) deletion to complete] *******************************
    FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
    changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '116212988029.1276838', 'results_file': '/home/rybalka/.ansible_async/116212988029.1276838', 'changed': True, 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:8', 'name': 'centos-8', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
    changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '839903046525.1276864', 'results_file': '/home/rybalka/.ansible_async/839903046525.1276864', 'changed': True, 'failed': False, 'item': {'command': '/sbin/init', 'image': 'centos:7', 'name': 'centos-7', 'tmpfs': ['/run', '/tmp'], 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup:ro']}, 'ansible_loop_var': 'item'})
    
    TASK [Delete docker network(s)] ************************************************
    
    PLAY RECAP *********************************************************************
    localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
    
--> Pruning extra files from scenario ephemeral directory
```
