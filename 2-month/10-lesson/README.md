# Домашнее задание №10

## Управление процессами

Работаем с процессами
Задания на выбор

1) написать свою реализацию ps ax используя анализ /proc  
   - Результат ДЗ - рабочий скрипт который можно запустить
2) написать свою реализацию lsof
   - Результат ДЗ - рабочий скрипт который можно запустить  
3) дописать обработчики сигналов в прилагаемом скрипте, оттестировать, приложить сам скрипт, инструкции по использованию
   - Результат ДЗ - рабочий скрипт который можно запустить + инструкция по использованию и лог консоли
4) реализовать 2 конкурирующих процесса по IO. пробовать запустить с разными ionice
   - Результат ДЗ - скрипт запускающий 2 процесса с разными ionice, замеряющий время выполнения и лог консоли
5) реализовать 2 конкурирующих процесса по CPU. пробовать запустить с разными nice
   - Результат ДЗ - скрипт запускающий 2 процесса с разными nice и замеряющий время выполнения и лог консоли

---

## Выполнение

1) [psax.sh](./psax.sh)

Скрипт `psax.sh`анализирует содержимое файловой системы `/proc` и выводит информацию о процессах по их PID.

### TTY

Показать путь к устройству TTY (используя команду tty) или:

- **`-`** if process hasn't FD `0`
- **`?`** if there is an error when try to get TTY device path

### STAT

Первый символ может быть одним из:

- **`D`** - uninterruptible sleep (usually IO)
- **`R`** - running or runnable (on run queue)
- **`S`** - interruptible sleep (waiting for an event to complete)
- **`T`** - stopped by job control signal
- **`t`** - stopped by debugger during the tracing
- **`W`** - paging (not valid since the 2.6.xx kernel)
- **`X`** - dead (should never be seen)
- **`Z`** - defunct ("zombie") process, terminated but not reaped by its parent

Следующим может быть один или несколько параметров

- **`<`**    high-priority (not nice to other users)
- **`N`**    low-priority (nice to other users)
- **`s`**    is a session leader
- **`l`**    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
- **`+`**    is in the foreground process group

### TIME

Совместное использование cpu time, user + system.

### COMMAND

Показать полную команду с аргументами.

> Примечания: в скрипте есть собственный обработчик сигналов для SIG_INT и SIG_TERM с использованием команды trap. Его можно переопределить в функции `terminate {...}`. Список сигналов доступен с помощью команды `kill -l`

## Запуск в vagrant

```shell
vagrant up
vagrant ssh
```

Запускаем скрипт

```shell
cd /vagrant
./psax.sh
```

```log
  PID TTY        STAT     TIME COMMAND
    1 ?          Ss        0:1 /usr/lib/systemd/systemd --switched-root --system --deserialize 22 
    2 -          S         0:0 [kthreadd]
    3 -          I<        0:0 [rcu_gp]
    4 -          I<        0:0 [rcu_par_gp]
    6 -          I<        0:0 [kworker/0:0H-kblockd]
    8 -          I<        0:0 [mm_percpu_wq]
    9 -          S         0:0 [ksoftirqd/0]
   10 -          I         0:2 [rcu_sched]
   11 -          S         0:0 [migration/0]
   13 -          S         0:0 [cpuhp/0]
   14 -          S         0:0 [cpuhp/1]
   15 -          S         0:0 [migration/1]
   16 -          S         0:0 [ksoftirqd/1]
   18 -          I<        0:0 [kworker/1:0H-kblockd]
   19 -          S         0:0 [cpuhp/2]
   20 -          S         0:0 [migration/2]
   21 -          S         0:0 [ksoftirqd/2]
   23 -          I<        0:0 [kworker/2:0H-kblockd]
   24 -          S         0:0 [cpuhp/3]
   25 -          S         0:0 [migration/3]
   26 -          S         0:0 [ksoftirqd/3]
   28 -          I<        0:0 [kworker/3:0H-kblockd]
   29 -          S         0:0 [kdevtmpfs]
   30 -          I<        0:0 [netns]
   31 -          S         0:0 [kauditd]
   32 -          S         0:0 [khungtaskd]
   33 -          S         0:0 [oom_reaper]
   34 -          I<        0:0 [writeback]
   35 -          S         0:0 [kcompactd0]
   36 -          SN        0:0 [ksmd]
   37 -          SN        0:0 [khugepaged]
  129 -          I<        0:0 [kintegrityd]
  130 -          I<        0:0 [kblockd]
  131 -          I<        0:0 [blkcg_punt_bio]
  132 -          I<        0:0 [tpm_dev_wq]
  133 -          I<        0:0 [md]
  134 -          I<        0:0 [edac-poller]
  135 -          I<        0:0 [devfreq_wq]
  136 -          S         0:0 [watchdogd]
  138 -          S         0:0 [kswapd0]
  141 -          I<        0:0 [kthrotld]
  142 -          I<        0:0 [acpi_thermal_pm]
  143 -          I<        0:0 [kmpath_rdacd]
  144 -          I<        0:0 [kaluad]
  146 -          I<        0:0 [kstrp]
  147 -          I<        0:0 [zswap-shrink]
  158 -          I<        0:0 [charger_manager]
  159 -          I<        0:0 [kworker/u9:0]
  380 -          I<        0:0 [ata_sff]
  381 -          S         0:0 [scsi_eh_0]
  384 -          I<        0:0 [scsi_tmf_0]
  385 -          S         0:0 [scsi_eh_1]
  386 -          I<        0:0 [scsi_tmf_1]
  399 -          I<        0:0 [kworker/0:1H-kblockd]
  401 -          I<        0:0 [kworker/1:1H-kblockd]
  463 -          I<        0:0 [kdmflush]
  472 -          I<        0:0 [kworker/3:1H-kblockd]
  475 -          I<        0:0 [kdmflush]
  478 -          I<        0:0 [kworker/2:1H-kblockd]
  488 -          I<        0:0 [xfsalloc]
  489 -          I<        0:0 [xfs_mru_cache]
  490 -          I<        0:0 [xfs-buf/dm-0]
  491 -          I<        0:0 [xfs-conv/dm-0]
  492 -          I<        0:0 [xfs-cil/dm-0]
  493 -          I<        0:0 [xfs-reclaim/dm-]
  494 -          I<        0:0 [xfs-eofblocks/d]
  495 -          I<        0:0 [xfs-log/dm-0]
  496 -          S         0:1 [xfsaild/dm-0]
  577 ?          Ss        0:0 /usr/lib/systemd/systemd-journald 
  602 ?          Ss        0:0 /usr/sbin/lvmetad -f 
  606 ?          Ss        0:0 /usr/lib/systemd/systemd-udevd 
  642 -          I<        0:0 [cryptd]
  643 -          I<        0:0 [iprt-VBoxWQueue]
  692 -          I<        0:0 [ttm_swap]
  735 -          I<        0:0 [xfs-buf/sda1]
  737 -          I<        0:0 [xfs-conv/sda1]
  738 -          I<        0:0 [xfs-cil/sda1]
  739 -          I<        0:0 [xfs-reclaim/sda]
  740 -          I<        0:0 [xfs-eofblocks/s]
  743 -          I<        0:0 [xfs-log/sda1]
  744 -          S         0:0 [xfsaild/sda1]
  761 ?          S<sl      0:0 /sbin/auditd 
  786 ?          Ssl       0:0 /usr/lib/polkit-1/polkitd --no-debug 
  787 ?          Ss        0:0 /usr/lib/systemd/systemd-logind 
  794 ?          Ss        0:7 /usr/sbin/irqbalance --foreground 
  795 ?          Ss        0:7 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation 
  800 ?          S         0:0 /usr/sbin/chronyd 
  809 ?          Ssl       0:2 /usr/sbin/NetworkManager --no-daemon 
  812 ?          Ss        0:0 /usr/sbin/crond -n 
  819 /dev/tty1  Ss+       0:0 /sbin/agetty --noclear tty1 linux 
  870 ?          S         0:0 /sbin/dhclient -d -q -sf /usr/libexec/nm-dhcp-helper -pf /var/run/dhclient-eth0.pid -lf /var/lib/NetworkManager/dhclient-8d87eabe-8db7-3364-a0b7-4116bc76ced6-eth0.lease -cf /var/lib/NetworkManager/dhclient-eth0.conf eth0 
 1050 ?          Ss        0:0 /usr/sbin/sshd -D 
 1052 ?          Ssl      0:14 /usr/bin/python2 -Es /usr/sbin/tuned -l -P 
 1053 ?          Ssl       0:7 /usr/sbin/rsyslogd -n 
 1166 ?          Ss        0:0 /usr/libexec/postfix/master -w 
 1170 ?          S         0:0 qmgr -l -t unix -u 
 1435 ?          Sl       0:21 /usr/sbin/VBoxService --pidfile /var/run/vboxadd-service.sh 
 2436 ?          S         0:0 pickup -l -t unix -u 
 2616 -          I         0:0 [kworker/u8:2-events_unbound]
 9574 ?          Ss        0:0 sshd: vagrant [priv] 
 9577 ?          S         0:0 sshd: vagrant@pts/1  
 9578 /dev/pts/1 Ss+       0:0 -bash 
 9837 -          I         0:0 [kworker/2:1-kdmflush]
19484 -          I         0:0 [kworker/3:3-cgroup_pidlist_destroy]
19486 -          I         0:0 [kworker/0:0]
19518 -          I         0:0 [kworker/1:3-cgroup_pidlist_destroy]
19519 -          I         0:0 [kworker/2:0-events]
19520 /dev/pts/1 S+        0:0 sudo ./psax.sh 
19521 /dev/pts/1 S+        0:0 bash ./psax.sh 
29669 -          I         0:0 [kworker/0:2-mm_percpu_wq]
29727 -          I         0:0 [kworker/3:0-mm_percpu_wq]
29788 -          I         0:4 [kworker/1:2-events]
32441 -          I         0:0 [kworker/u8:1-events_unbound]
```

---

2) [ionice.sh](./ionice.sh)
Сценарий `ionice.sh` запускает 2 фоновых процесса `dd` с классом `Best-effort` и приоритетом `0` и `7` и запускает `iotop` в пакетном режиме, чтобы показать результат.

## Классы

- **Idle** - программа, работающая с приоритетом простоя ввода-вывода, получит время на диске только тогда, когда никакая другая программа не запросила дисковый ввод-вывод в течение определенного периода отсрочки. Влияние бездействующего процесса ввода-вывода на нормальную работу системы должно быть нулевым. Этот класс планирования не принимает аргумент приоритета. В настоящее время этот класс планирования разрешен для обычного пользователя (начиная с ядра 2.6.25).

- **Best-effort** - это эффективный класс планирования для любого процесса, который не запрашивал определенный приоритет ввода-вывода. Этот класс принимает аргумент приоритета от 0 до 7, при этом меньшее число имеет более высокий приоритет. Программы, работающие с одним и тем же приоритетом максимального усилия, обслуживаются циклически.
Обратите внимание, что до ядра 2.6.26 процесс, который не запрашивал приоритет ввода-вывода, формально использовал "none" в качестве класса планирования, но планировщик ввода-вывода будет обрабатывать такие процессы, как если бы он находился в классе наилучшего усилия. Приоритет в классе наилучшего усилия будет динамически извлекаться из уровня обработки ЦП процесса: io_priority = (cpu_nice + 20) / 5.
Для ядер после 2.6.26 с планировщиком ввода-вывода CFQ процесс, который не запрашивал приоритет ввода-вывода, наследует его класс планирования ЦП. Приоритет ввода-вывода зависит от уровня готовности процессора к процессу (так же, как и до ядра 2.6.26).
- **Realtime** - классу планирования RT предоставляется первый доступ к диску, независимо от того, что еще происходит в системе. Таким образом, класс RT следует использовать с некоторой осторожностью, поскольку он может истощить другие процессы. Как и в случае с классом максимального усилия, определены 8 уровней приоритета, обозначающие, насколько большой временной отрезок данный процесс получит в каждом окне планирования. Этот класс планирования не разрешен для обычного пользователя (т. Е. Без полномочий root).

>Примечания: ionice работает только с планировщиком cfq. Но в ядре 5.6 нет cfq. Из-за этого нам нужно перезагрузиться с версией ядра 3.10.

Перегружаемся с ядром 3.10

```shell
echo "sudo grub2-set-default 0 && sudo reboot" | vagrant ssh
vagrant ssh
```

Устанавливаем плпнировщик `cfq`

```shell
echo cfq | sudo tee /sys/block/sda/queue/scheduler
```

Создаём функцию и запускаем тесты

```shell
##
# Functions
##
run_ioniced() {
    PRIO=$1
    ionice -c 2 -n $PRIO dd if=/dev/zero of=/tmp/prio-${PRIO}.2Gb bs=1M count=2048 oflag=direct &
}

##
# Run tests
##
{
    run_ioniced 0
    run_ioniced 7
    sudo iotop -obn 5
}
```

Логи:

```log
[1] 1585
[2] 1586
Total DISK READ :       0.00 B/s | Total DISK WRITE :     518.69 M/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:     518.69 M/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
 1586 be/7 vagrant     0.00 B/s  518.69 M/s  0.00 % 54.18 % dd if=/dev/zero of=/tmp/prio-7.2Gb bs=1M count=2048 oflag=direct
Total DISK READ :       0.00 B/s | Total DISK WRITE :     845.85 M/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:     845.85 M/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
 1585 be/0 vagrant     0.00 B/s  661.62 M/s  0.00 % 92.92 % dd if=/dev/zero of=/tmp/prio-0.2Gb bs=1M count=2048 oflag=direct
 1586 be/7 vagrant     0.00 B/s  184.22 M/s  0.00 % 83.39 % dd if=/dev/zero of=/tmp/prio-7.2Gb bs=1M count=2048 oflag=direct
Total DISK READ :       0.00 B/s | Total DISK WRITE :     538.76 M/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:     538.76 M/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
 1586 be/7 vagrant     0.00 B/s  139.57 M/s  0.00 % 99.99 % dd if=/dev/zero of=/tmp/prio-7.2Gb bs=1M count=2048 oflag=direct
 1585 be/0 vagrant     0.00 B/s  399.19 M/s  0.00 % 91.20 % dd if=/dev/zero of=/tmp/prio-0.2Gb bs=1M count=2048 oflag=direct
Total DISK READ :       0.00 B/s | Total DISK WRITE :     547.91 M/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:     547.91 M/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
 1585 be/0 vagrant     0.00 B/s  411.90 M/s  0.00 % 90.45 % dd if=/dev/zero of=/tmp/prio-0.2Gb bs=1M count=2048 oflag=direct
 1586 be/7 vagrant     0.00 B/s  136.01 M/s  0.00 % 82.16 % dd if=/dev/zero of=/tmp/prio-7.2Gb bs=1M count=2048 oflag=direct
Total DISK READ :       0.00 B/s | Total DISK WRITE :     696.45 M/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:     696.70 M/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
 1586 be/7 vagrant     0.00 B/s  207.45 M/s  0.00 % 99.99 % dd if=/dev/zero of=/tmp/prio-7.2Gb bs=1M count=2048 oflag=direct
 1585 be/0 vagrant     0.00 B/s  489.00 M/s  0.00 % 89.79 % dd if=/dev/zero of=/tmp/prio-0.2Gb bs=1M count=2048 oflag=direct
[vagrant@hw10-proc ~]$ 2048+0 записей получено
2048+0 записей отправлено
 скопировано 2147483648 байт (2,1 GB), 4,17328 c, 515 MB/c
2048+0 записей получено
2048+0 записей отправлено
 скопировано 2147483648 байт (2,1 GB), 5,39265 c, 398 MB/c

[1]-  Done                    ionice -c 2 -n $PRIO dd if=/dev/zero of=/tmp/prio-${PRIO}.2Gb bs=1M count=2048 oflag=direct
[2]+  Done                    ionice -c 2 -n $PRIO dd if=/dev/zero of=/tmp/prio-${PRIO}.2Gb bs=1M count=2048 oflag=direct
```

Как мы видим, процесс с приоритетом 0 (pid 1585) имеет большую скорость записи, чем процесс с приоритетом 7 (pid 1586).
