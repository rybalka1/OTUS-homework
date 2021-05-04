#!/bin/sh

set -eu

yum install -y lvm2
pvcreate /dev/sdb
vgcreate backup_pool /dev/sdb
lvcreate -l+1000%FREE -n backup backup_pool
mkfs.ext4 /dev/backup_pool/backup
mkdir -p /var/backup
mount /dev/backup_pool/backup /var/backup
echo "/dev/backup_pool/backup  /var/backup     ext4     defaults 0      2" >> /etc/fstab
