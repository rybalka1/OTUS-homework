# Домашнее задание №3

По заданию выполнил все пункты меню получилась вот такая таблица разделов:

![alt text](https://github.com/rybalka1/OTUS-homework/blob/master/1-month/3-lesson/photo_2021-02-07_22-45-16.jpg "Logo Title Text 1")

Далее отформатировал диск sdb и sde в файловую систему btrfs:

![alt text](https://github.com/rybalka1/OTUS-homework/blob/master/1-month/3-lesson/photo_2021-02-07_22-45-18.jpg "Диск sdb")

![alt text](https://github.com/rybalka1/OTUS-homework/blob/master/1-month/3-lesson/photo_2021-02-07_22-45-21.jpg "Диск sde")

Добавил эти диски в fstab:

![alt text](https://github.com/rybalka1/OTUS-homework/blob/master/1-month/3-lesson/photo_2021-02-07_22-58-50.jpg "fstab")

Протестировал как работают снапшоты, руководствуясь вот этой статьёй:

https://help.ubuntu.ru/wiki/btrfs

Далее создал vagrant box и залил его на:

https://app.vagrantup.com/rybalka1/boxes/3-lesson_lvm

Конфингурация виртуальной машины:

https://github.com/rybalka1/OTUS-homework/blob/master/1-month1-month/3-lesson/Vagrantfile