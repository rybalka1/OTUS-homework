#!/usr/bin/env bash
###
# analyze nginx's access.log and send results to email
###

set -eo pipefail

usage() {
  echo "Usage: $0 options"
  printf "\t-r|--recipient <destination email> - email address to send statistics to. Default root\n"
  printf "\t-l|--logfile <path/to/access.log> - path to nginx access.log to analyse. Default ./access.log\n"
  printf "\t-L|--lockfile <path/to/lockfile.lock> - path to lockfile. Default /tmp/script.lock\n"
  printf "\t-T|--top <num> - report top <num> results. Default 10\n"
  printf "\t-h|--help - Print this help and exit\n"
  exit 0
}

# Run on script termination
terminate() {
  echo "Terminated! Removing lockfile $LOCKFILE"
  rm -f "$LOCKFILE"
  rm -f "$MSGBODY_FILE"
  exit $?
}

send_email() {
  cat $MSGBODY_FILE | mail -s 'access.log stats' $RECIPIENT
}

# define variables
MSGBODY_FILE=$(mktemp)

# Set default values for variables
RECIPIENT='root'
LOGFILE='./access.log'
LOCKFILE='/tmp/script.lock'
TOP=10

# Parse arguments
while true; do
  case "$1" in
  -r | --recipient)
    RECIPIENT="${2}"
    shift 2
    ;;
  -l | --logfile)
    LOGFILE="${2}"
    shift 2
    ;;
  -L | --lockfile)
    LOCKFILE="${2}"
    shift 2
    ;;
  -T | --top)
    TOP="${2}"
    shift 2
    ;;
  -h | --help)
    usage
    shift 1
    ;;
  --)
    shift
    break
    ;;
  *) break ;;
  esac
done

# debug options
cat <<EOF
RECIPIENT=$RECIPIENT
LOGFILE=$LOGFILE
LOCKFILE=$LOCKFILE
TOP=$TOP
MSGBODY_FILE=$MSGBODY_FILE
EOF

# Try to acquire lockfile
if (
  set -o noclobber
  echo "$$" >"$LOCKFILE"
) 2>/dev/null; then
  trap 'terminate' INT TERM EXIT
else
  echo "Failed to acquire lockfile: $LOCKFILE."
  echo "Held by $(cat ${LOCKFILE})"
  exit 1
fi

##
# Define filters
##
http_only() {
  grep --color=never -P ' HTTP/[\d\.]+"'
}

##
# Define analyzers
##
top_n() {
  awk '{ print $1; }' | sort -n | uniq -c | sort -rn | head -n $TOP
}

##
# Read log by STEP lines at once
##
ITERATION=0
STEP=100
FROM_LINE=$(($STEP * $ITERATION))
TO_LINE=$(($STEP * $ITERATION + $STEP))
LINES_COUNT=$(wc -l <"$LOGFILE")
while [[ $FROM_LINE < $LINES_COUNT ]]; do
  if [ $TO_LINE -gt $LINES_COUNT ]; then
    TO_LINE=$LINES_COUNT
  fi
  # Period
  FROM_DT=$(awk "NR == $(($FROM_LINE + 1))" $LOGFILE | cut -d"[" -f2 | cut -d"]" -f1)
  TO_DT=$(awk "NR == $TO_LINE" $LOGFILE | cut -d"[" -f2 | cut -d"]" -f1)
  echo "Period from $FROM_DT to $TO_DT" >$MSGBODY_FILE
  # Top IPs
  echo "--------" >>$MSGBODY_FILE
  echo "Top $TOP IPs" >>$MSGBODY_FILE
  awk "NR >= $FROM_LINE && NR <= $TO_LINE" $LOGFILE | awk '{ print $1; }' | top_n >>$MSGBODY_FILE
  # Top requested URIs
  echo "--------" >>$MSGBODY_FILE
  echo "Top $TOP requested URIs" >>$MSGBODY_FILE
  awk "NR >= $FROM_LINE && NR <= $TO_LINE" $LOGFILE | http_only | awk '{ print $7; }' | top_n >>$MSGBODY_FILE
  # Return codes
  echo "--------" >>$MSGBODY_FILE
  echo "Return codes count" >>$MSGBODY_FILE
  awk "NR >= $FROM_LINE && NR <= $TO_LINE" $LOGFILE | http_only | awk '{ print $9; }' | sort -n | uniq -c | sort -rn >>$MSGBODY_FILE
  # Errors
  echo "--------" >>$MSGBODY_FILE
  printf "Errors (4xx and 5xx):\n\n" >>$MSGBODY_FILE
  awk "NR >= $FROM_LINE && NR <= $TO_LINE" $LOGFILE | http_only | awk '$9 ~ /[45][0-9]{2}/ { print $0; }' >>$MSGBODY_FILE
  echo "" >>$MSGBODY_FILE

  # Iterate
  ITERATION=$(($ITERATION + 1))
  FROM_LINE=$(($STEP * $ITERATION))
  TO_LINE=$(($FROM_LINE + $STEP))

  send_email $MSGBODY_FILE
done
