# Домашнее задание №4

## Практические навыки работы с ZFS
Цель: Отрабатываем навыки работы с созданием томов export/import и установкой параметров.

Определить алгоритм с наилучшим сжатием.
Определить настройки pool’a
Найти сообщение от преподавателей

Результат:
список команд которыми получен результат с их выводами

1. Определить алгоритм с наилучшим сжатием

Зачем:
Отрабатываем навыки работы с созданием томов и установкой параметров. Находим наилучшее сжатие.


Шаги:
- определить какие алгоритмы сжатия поддерживает zfs (gzip gzip-N, zle lzjb, lz4)
- создать 4 файловых системы на каждой применить свой алгоритм сжатия
Для сжатия использовать либо текстовый файл либо группу файлов:
- скачать файл “Война и мир” и расположить на файловой системе
wget -O War_and_Peace.txt http://www.gutenberg.org/ebooks/2600.txt.utf-8
либо скачать файл ядра распаковать и расположить на файловой системе

Результат:
создал pool raidz3
`zpool create raid raidz3 sdb sdc sdd sde sdf`  
Создал файловые системы по имени метода сжатия, которые будут к ним применяться:
`zfs create storage/gzip`  
`zfs create raid/gzip-9`  
`zfs create raid/zle`  
`zfs create raid/lz4`  
`zfs create raid/lzjb`  
Вывод команды из которой видно какой из алгоритмов лучше:
`zfs get compression,compressratio`

## 2. Определить настройки pool’a

Зачем:
Для переноса дисков между системами используется функция export/import. Отрабатываем навыки работы с файловой системой ZFS

Шаги:
- Загрузить архив с файлами локально.
https://drive.google.com/open?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg
Распаковать.
- С помощью команды zfs import собрать pool ZFS.
- Командами zfs определить настройки
- размер хранилища
- тип pool
- значение recordsize
- какое сжатие используется
- какая контрольная сумма используется
Результат:
```gzip -d zfs_task1.tar.gz```

```tar -xf zfs_task1.tar```  

```cd zpoolexport/```  

```zpool import -d ${PWD}/zpoolexport```

```
pool: otus
     id: 6554193320433390805
  state: ONLINE
 action: The pool can be imported using its name or numeric identifier.
 config:

	otus                                 ONLINE
	  mirror-0                           ONLINE
	    /home/vagrant/zpoolexport/filea  ONLINE
	    /home/vagrant/zpoolexport/fileb  ONLINE
```

```zpool import -d ${PWD} otus```

```zpool status```

```
  pool: otus
 state: ONLINE
  scan: none requested
config:

	NAME                                 STATE     READ WRITE CKSUM
	otus                                 ONLINE       0     0     0
	  mirror-0                           ONLINE       0     0     0
	    /home/vagrant/zpoolexport/filea  ONLINE       0     0     0
	    /home/vagrant/zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors

  pool: raid
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	raid        ONLINE       0     0     0
	  raidz3-0  ONLINE       0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     ONLINE       0     0     0
	    sdd     ONLINE       0     0     0
	    sde     ONLINE       0     0     0
	    sdf     ONLINE       0     0     0

errors: No known data errors
```

```cd /otus/hometask2/```

```ls -l```

```
total 250
drwxr-xr-x. 102 root root 102 May 15  2020 dir1
drwxr-xr-x. 102 root root 102 May 15  2020 dir10
drwxr-xr-x. 102 root root 102 May 15  2020 dir100
drwxr-xr-x. 102 root root 102 May 15  2020 dir11
drwxr-xr-x. 102 root root 102 May 15  2020 dir12
drwxr-xr-x. 102 root root 102 May 15  2020 dir13
drwxr-xr-x. 102 root root 102 May 15  2020 dir14
drwxr-xr-x. 102 root root 102 May 15  2020 dir15
drwxr-xr-x. 102 root root 102 May 15  2020 dir16
drwxr-xr-x. 102 root root 102 May 15  2020 dir17
drwxr-xr-x. 102 root root 102 May 15  2020 dir18
drwxr-xr-x. 102 root root 102 May 15  2020 dir19
drwxr-xr-x. 102 root root 102 May 15  2020 dir2
drwxr-xr-x. 102 root root 102 May 15  2020 dir20
drwxr-xr-x. 102 root root 102 May 15  2020 dir21
drwxr-xr-x. 102 root root 102 May 15  2020 dir22
......
......
```

## 3. Найти сообщение от преподавателей

Зачем:
для бэкапа используются технологии snapshot. Snapshot можно передавать между хостами и восстанавливать с помощью send/receive. Отрабатываем навыки восстановления snapshot и переноса файла.

Шаги:
- Скопировать файл из удаленной директории. https://drive.google.com/file/d/1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG/view?usp=sharing
Файл был получен командой
zfs send otus/storage@task2 > otus_task2.file
- Восстановить файл локально. zfs receive
- Найти зашифрованное сообщение в файле secret_message

Результат:
```zfs receive otus/secret < otus_task2.file```  

```ls -l /otus/secret/```

```
total 2590
-rw-r--r--. 1 root    root          0 May 15  2020 10M.file
-rw-r--r--. 1 root    root     309987 May 15  2020 Limbo.txt
-rw-r--r--. 1 root    root     509836 May 15  2020 Moby_Dick.txt
-rw-r--r--. 1 root    root    1209374 May  6  2016 War_and_Peace.txt
-rw-r--r--. 1 root    root     727040 May 15  2020 cinderella.tar
-rw-r--r--. 1 root    root         65 May 15  2020 for_examaple.txt
-rw-r--r--. 1 root    root          0 May 15  2020 homework4.txt
drwxr-xr-x. 3 vagrant vagrant       4 Dec 18  2017 task1
-rw-r--r--. 1 root    root     398635 May 15  2020 world.sql
```

```cat /otus/secret/task1/file_mess/secret_message```

```
https://github.com/sindresorhus/awesome
```
Ответ это ссылка на репозиторий:
<https://github.com/sindresorhus/awesome>

Лог выполненой работы.
<https://github.com/rybalka1/OTUS-homework/blob/master/1-month/4-lesson/dz-main>