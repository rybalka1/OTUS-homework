# Домашнее задание №9

## Bash

Пишем скрипт
написать скрипт для крона
который раз в час присылает на заданную почту

- X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
- Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
- все ошибки c момента последнего запуска
- список всех кодов возврата с указанием их кол-ва с момента последнего запуска
в письме должно быть прописан обрабатываемый временной диапазон
должна быть реализована защита от мультизапуска

___
## Выполнение

Скрипт, который анализирует журнал nginx access.log по 100 строк за раз и отправляет статистику по электронной почте.  
[parser100.sh](./files/parser100.sh)  
Краткий мануал скрипта:

```shell
./parser100.sh -h
Usage: ./script.sh options
        -r|--recipient <destination email> - email address to send statistics to. Default root
        -l|--logfile <path/to/access.log> - path to nginx access.log to analyse. Default ./access.log
        -L|--lockfile <path/to/lockfile.lock> - path to lockfile. Default /tmp/script.lock
        -T|--top <num> - report top <num> results. Default 10
        -h|--help - Print this help and exit
```

Запускаем скрипт на виртуальной машине

```shell
vagrant up
vagrant ssh
```

Переходим в каталог скрипта и запускаем с аргументами или без них (в этом примере скрипт показывает верхние 5 вместо верхних 10 ips/uris/etc ... и отправляет электронное письмо локальному пользователю `vagrant`)

```shell
cd /vagrant/files
./parser100.sh -T 5 -r vagrant
```

Проверяем почтовый ящик пользователя

```shell
mail
```

___
Ещё один способ, это когда скрипт читает строки, которые были добавлены с последнего запуска (или с начала файла)

[parser-last.sh](./files/parser-last.sh)

Важно: по умолчанию скрипт сохраняет состояние в каталог `/var/spool/nginx_log_analyzer`. Таким образом, этот путь должен существовать и быть доступным для записи пользователю, который запускает скрипт.

Использование скрипта:

```shell
 ./parser-last.sh -h
        -r|--recipient <destination email> - email address to send statistics to. Default: 'root'
        -l|--logfile <path/to/access.log> - path to nginx access.log to analyse. Default: './access.log'
        -L|--lockfile <path/to/lockfile.lock> - path to lockfile. Default: '/tmp/script.lock'
        -S|--state-dir <path/to/state/directory> - path to directory to save state. Default: '/var/spool/nginx_log_analyzer'
        -T|--top <num> - report top <num> results. Default: 10
        -h|--help - Print this help and exit
```

Запускаем виртуальную машину

```shell
vagrant up
vagrant ssh
```

Переходим в каталог скрипта и запускаем с аргументами или без них (в этом примере скрипт показывает верхние 5 вместо верхних 10 ips/uris/etc ... и отправляет электронное письмо локальному пользователю `vagrant`)

```shell
cd /vagrant/files
./parser-last.sh -T 5 -r vagrant
```

And check user's mailbox

```shell
mail
```

Можно указать, с какой строки начинать парсинг. Для этого необходимо установить значение переменной `FROM_LINE =` в файле состояния (по умолчанию `/var/spool/nginx_log_analyzer/state.env`)

Скрипт развертывается автоматически с механизмом vagrant Provisioning.

[Provision script](./scripts/2-install.sh):
- создаёт systemd oneshot [service](./files/nla.service) который запускает [logs analyzer](./files/parser-last.sh)
- создаёт systemd [timer](./giles/../files/nla.timer) для запуска службы раз в час
- создаёт [config](./files/nla) для передачи аргументов скрипту
- копирует журнал для задания [example](./files/access.log)
