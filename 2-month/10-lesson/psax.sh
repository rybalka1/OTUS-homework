#!/usr/bin/env bash
##
# Display info about running processes based on infromation from /proc
##

set -eu

# Set working directory
PSAX_PROC="/proc"

##
# Functions
##
# Run on script termination
terminate() {
    echo "Script is terminated"
    exit $?
}

# Print formatted line
write_line() {
    printf "%5s %-10s %-7s %5s %s\n" "$1" "$2" "$3" "$4" "$5"
}

# Get TTY dev
get_tty() {
    PID="$1"
    RESULT=""
    if [ -e "${PSAX_PROC}/${PID}/fd/0" ]; then
        RESULT=$(tty <"${PSAX_PROC}/${PID}/fd/0" 2>/dev/null) || RESULT="?"
    else
        RESULT="-"
    fi
    echo "$RESULT"
}

# Get STAT
get_state() {
    PID="$1"
    # Get status
    RESULT=$(cut -d" " -f3 "${PSAX_PROC}/${PID}/stat")
    # Get priority
    STATE_NICE=$(cut -d" " -f19 "${PSAX_PROC}/${PID}/stat")
    if [ $STATE_NICE -lt 0 ]; then
        RESULT="${RESULT}<"
    elif [ $STATE_NICE -gt 0 ]; then
        RESULT="${RESULT}N"
    fi
    # Is process a session leader?
    STATE_SESSION_ID=$(cut -d" " -f6 "${PSAX_PROC}/${PID}/stat")
    if [ $STATE_SESSION_ID -eq $PID ]; then
        RESULT="${RESULT}s"
    fi
    # Get threads
    STATE_THREADS=$(cut -d" " -f20 "${PSAX_PROC}/${PID}/stat")
    if [ $STATE_THREADS -gt 1 ]; then
        RESULT="${RESULT}l"
    fi
    # Get ID of foreground process group
    STATE_FGID=$(cut -d" " -f8 "${PSAX_PROC}/${PID}/stat")
    if [ $STATE_FGID -ge 0 ]; then
        RESULT="${RESULT}+"
    fi

    echo "$RESULT"
}

# Get TIME
get_time() {
    PID="$1"
    # https://straypixels.net/getting-the-cpu-time-of-a-process-in-bash-is-difficult/
    CLK_TCK=$(getconf CLK_TCK)
    # https://unix.stackexchange.com/questions/7870/how-to-check-how-long-a-process-has-been-running
    TIME_TCK=$(awk '{ print $14+$15 }' "${PSAX_PROC}/${PID}/stat")
    RESULT="$(($TIME_TCK / $CLK_TCK / 60)):$(($TIME_TCK / $CLK_TCK % 60))"
    echo "$RESULT"
}

# Get CMDLINE
get_cmdline() {
    PID="$1"
    RESULT=$(cat "${PSAX_PROC}/${PID}/cmdline" | tr "\0" " ")
    test -z "$RESULT" && RESULT="[$(cat "${PSAX_PROC}/${PID}/comm")]"
    echo "$RESULT"
}

# Set custom handler for sigals INT TERM
trap 'terminate' INT TERM

# Write header
write_line PID TTY STAT TIME COMMAND

# Get pids
cd "$PSAX_PROC"
PSAX_PIDS=$(ls -d1 */ | grep -P "^\d+/$" | sort -n | tr -d "/")

# Get processes info
for PSAX_PID in $PSAX_PIDS; do
    # If PID doesn't exists, skip it
    test -d "$PSAX_PID" || continue
    # Get TTY
    PSAX_TTY=$(get_tty "$PSAX_PID")
    # Get process state
    PSAX_STAT=$(get_state "$PSAX_PID")
    # Get time
    PSAX_TIME=$(get_time "$PSAX_PID")
    # Get cmdline
    PSAX_CMDLINE=$(get_cmdline "$PSAX_PID")
    # Excho result
    write_line "$PSAX_PID" "$PSAX_TTY" "$PSAX_STAT" "$PSAX_TIME" "$PSAX_CMDLINE"
done
