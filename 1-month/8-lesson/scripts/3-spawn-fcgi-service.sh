#!/bin/sh

set -exuo pipefail

echo Install necessary packages
sudo yum install -y spawn-fcgi php-cli

echo Provide config
sudo cp spawn-fcgi /etc/sysconfig/spawn-fcgi
sudo chown root:root /etc/sysconfig/spawn-fcgi

echo Provide systemd service
sudo cp spawn-fcgi.service /etc/systemd/system/spawn-fcgi.service
sudo chown root:root /etc/systemd/system/spawn-fcgi.service
echo Reread systemd unit-files
sudo systemctl daemon-reload

echo Enamble and start service
sudo systemctl enable spawn-fcgi.service
sudo systemctl start spawn-fcgi.service

echo Check service running
sudo systemctl status spawn-fcgi
