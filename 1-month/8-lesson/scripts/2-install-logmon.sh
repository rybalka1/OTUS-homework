#!/bin/sh

set -exu

echo Clean pervious log
test -f /tmp/logmon.log && rm -f /tmp/logmon.log

echo Ensure user is created
id logmon || sudo adduser --no-create-home --no-user-group --gid systemd-journal --shell /usr/sbin/nologin logmon

echo Provide logmon.sh script
sudo cp logmon.sh /usr/local/bin/logmon.sh
sudo chown root:root /usr/local/bin/logmon.sh
sudo chmod +x /usr/local/bin/logmon.sh

echo Provide config
sudo cp logmon /etc/sysconfig/logmon
sudo chown root:root /etc/sysconfig/logmon


echo Provide systemd service
sudo cp logmon.service /etc/systemd/system/logmon.service
sudo chown root:root /etc/systemd/system/logmon.service
echo Reread systemd unit-files
sudo systemctl daemon-reload

echo Start service
sudo systemctl enable logmon.service
sudo systemctl start logmon.service

# Disable debug to prevent redundant output
set +x
echo Send test message to log
logger Test message with logmon pattern 'testmsg' in it
# until ls -l /tmp/logmon.log; do sleep 1; done
# # now we must wait until logmon service parse journald
# # log and write message to log, but we wan't to wait 30 seconds ^_^
# # so, these lines are commented
# cat /tmp/logmon.log
