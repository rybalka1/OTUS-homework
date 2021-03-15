#!/bin/bash
##
# Test ionice
##

set -eu

##
# Functions
##
run_ioniced() {
    PRIO=$1
    ionice -c 2 -n $PRIO dd if=/dev/zero of=/tmp/prio-${PRIO}.2Gb bs=1M count=2048 oflag=direct &
}

##
# Run tests
##
{
    run_ioniced 0
    run_ioniced 7
    sudo iotop -obn 5
}
