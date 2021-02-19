#!/bin/sh

set -eux

echo "Get current VGs"
sudo vgs | tee /home/vagrant/vgs-old.log

echo "Rename VG centos to OtusRoot"
sudo vgrename centos OtusRoot

echo "Update configs"
sudo sed -i.old 's#^/dev/mapper/centos-#/dev/mapper/OtusRoot-#g' /etc/fstab
sudo sed -i.old 's#lvm.lv=centos/#lvm.lv=OtusRoot/#g' /etc/default/grub
sudo sed -i.old1 's#/dev/mapper/centos-#/dev/mapper/OtusRoot-#g' /boot/grub2/grub.cfg
sudo sed -i.old2 's#lvm.lv=centos/#lvm.lv=OtusRoot/#g' /boot/grub2/grub.cfg

echo "Recreate initrd"
sudo mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)

echo "Reboot"
sudo shutdown -r now
