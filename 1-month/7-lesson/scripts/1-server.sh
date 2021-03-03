#!/bin/bash

set -eux

echo "Install packages for NFS server"
sudo yum install -y nfs-utils

echo "Enable services for NFS server"
sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl enable rpc-statd
sudo systemctl enable nfs-idmapd

echo "Start nfs services"
sudo systemctl start rpcbind
sudo systemctl start nfs-server
sudo systemctl start rpc-statd
sudo systemctl start nfs-idmapd

echo "Create directory"
sudo mkdir -p /export/shared
sudo chmod 0777 /export/shared

echo "Provide config"
cat << EOF | sudo tee /etc/exports
/export/shared  192.168.10.0/24(rw,async)
EOF

echo "Apply config changes"
sudo exportfs -ra

echo "Enable firewall"
{
  sudo systemctl enable firewalld
  sudo systemctl start firewalld
  sudo firewall-cmd --permanent --add-service=nfs3
  sudo firewall-cmd --permanent --add-service=mountd
  sudo firewall-cmd --permanent --add-service=rpc-bind
  sudo firewall-cmd --reload
  sudo firewall-cmd --list-all
}
