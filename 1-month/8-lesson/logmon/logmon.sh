#!/bin/bash
###
# This script tail journalctl logs for PATTERN and append founded mesages to LOG
###

set -eo pipefail

# set locale
LANG=C

# Paths to binaries
JOURNALCTL="/usr/bin/journalctl"
GREP="/usr/bin/grep"
JQ="/usr/bin/jq"
XARGS="/usr/bin/xargs"
TRUE="/usr/bin/true"

# Filename to log pattern matches
LOG=${LOG:-/tmp/logmon.log}
# Read log every $SEC seconds
SEC=${SEC:=30}
# grep template pattern
PATTERN=${PATTERN:-testmsg}


# Run on script termination (just for test purposes)
terminate() {
    echo "Terminated by SIGINT or SIGTERM"
    exit 0
}


# Catch SIGINT and SIGTERM
trap 'terminate' 2 15

# Get last journalctl cursor
CURSOR=$($JOURNALCTL -n1 -o json | $JQ .'__CURSOR' | $XARGS)

while sleep $SEC
do
    # Unfortunately journalctl on CentOS7 can't --cursor-file :((
    #$JOURNALCTL --since=-${SEC}s --cursor-file=$CURSOR_FILE -o cat
    $JOURNALCTL --cursor="$CURSOR" --no-pager | $GREP "$PATTERN" >> $LOG || $TRUE
    CURSOR=$($JOURNALCTL -n1 -o json | $JQ .'__CURSOR' | $XARGS)
done
