#!/bin/sh

set -eu

echo "Print some info about a host"
echo I am "$(whoami)"
echo I am at "$(pwd)"
echo My host name is "$(hostname -f)"
echo I run on kernel "$(uname -a)"
