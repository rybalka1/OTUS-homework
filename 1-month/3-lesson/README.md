# Домашнее задание №3

1) Уменшить том под / до 8G
2) Выделить том под /home
3) Выделить том под /var - сделать в mirror
4) /home - сделать том для снапшотов
5) Прописать монтирование в fstab. Попробовать с разными опциями и разными
файловыми системами (на выбор)
Работа со снапшотами:
- сгенерировать файлы в /home/
- снять снапшот
- удалить часть файлов
- восстановится со снапшота
- залоггировать работу, можно с помощью утилиты script

По заданию выполнил все пункты меню получилась вот такая таблица разделов:

![alt text](https://github.com/rybalka1/OTUS-homework/blob/master/1-month/3-lesson/photo_2021-02-07_22-45-16.jpg "Logo Title Text 1")

Далее отформатировал диск sdb и sde в файловую систему btrfs:

![alt text](https://github.com/rybalka1/OTUS-homework/blob/master/1-month/3-lesson/photo_2021-02-07_22-45-18.jpg "Диск sdb")

![alt text](https://github.com/rybalka1/OTUS-homework/blob/master/1-month/3-lesson/photo_2021-02-07_22-45-21.jpg "Диск sde")

Добавил эти диски в fstab:

![alt text](https://github.com/rybalka1/OTUS-homework/blob/master/1-month/3-lesson/photo_2021-02-07_22-58-50.jpg "fstab")

Протестировал как работают снапшоты, руководствуясь вот этой статьёй:

<https://help.ubuntu.ru/wiki/btrfs>

Далее создал vagrant box и залил его на:

<https://app.vagrantup.com/rybalka1/boxes/3-lesson_lvm>

Конфингурация виртуальной машины:

<https://github.com/rybalka1/OTUS-homework/blob/master/1-month1-month/3-lesson/Vagrantfile>

Лог выполненой работы.  

<https://github.com/rybalka1/OTUS-homework/blob/master/1-month/3-lesson/lab03-lvm>
