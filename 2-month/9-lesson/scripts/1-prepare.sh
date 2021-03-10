#!/bin/sh

set -eu

echo "Add EPEL repo"
sudo yum install -y epel-release

echo "Install necessary packages"
sudo yum install -y vim-enhanced bash-completion mailx
