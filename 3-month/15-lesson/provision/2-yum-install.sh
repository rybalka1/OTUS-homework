#!/bin/sh

set -eu

yum install -y wget
wget https://github.com/borgbackup/borg/releases/download/1.1.16/borg-linux64 -O /usr/local/bin/borg
chmod +x /usr/local/bin/borg
