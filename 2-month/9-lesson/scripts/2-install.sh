#!/bin/sh

set -eu

echo Ensure user is created
id nla || sudo adduser --no-create-home --shell /usr/sbin/nologin nla

echo Provide nla.sh script
sudo cp parser-last.sh /usr/local/bin/nla.sh
sudo chown root:root /usr/local/bin/nla.sh
sudo chmod +x /usr/local/bin/nla.sh

echo Provide config
sudo cp nla /etc/sysconfig/nla
sudo chown root:root /etc/sysconfig/nla

echo "Create state directory for parser-last.sh"
sudo mkdir -p /var/spool/nginx_log_analyzer
sudo chown nla:nla /var/spool/nginx_log_analyzer

echo "Place example log file to /var/log/nginx/example.log"
sudo mkdir -p /var/log/nginx
sudo cp access.log /var/log/nginx/example.log

echo Provide systemd service
sudo cp nla.service /etc/systemd/system/nla.service
sudo chown root:root /etc/systemd/system/nla.service
sudo cp nla.timer /etc/systemd/system/nla.timer
sudo chown root:root /etc/systemd/system/nla.timer
echo Reread systemd unit-files
sudo systemctl daemon-reload

echo Start service
sudo systemctl enable nla.service
sudo systemctl enable nla.timer
sudo systemctl start nla.timer
