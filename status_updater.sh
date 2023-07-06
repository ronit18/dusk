#!/bin/sh

for pid in $(pidof -x "status_updater.sh"); do
    if [ $pid != $$ ]; then
        echo "$(date +"%F %T"): status_updater.sh is already running with PID $pid, killing"
        kill $pid
    fi
done

# Add an artificial sleep to wait for the IPC handler to be ready to process requests
sleep 0.5

SETSTATUS="duskc --ignore-reply run_command setstatus"

#$SETSTATUS 7 "$(~/bin/statusbar/statusbutton)" &

# do these first as they are not done frequently

$SETSTATUS 2 "$(/usr/local/bin/d-sb-vol)" &

secs=0
while true; do

    $SETSTATUS 0 "$(/usr/local/bin/d-sb-clock)" &
    $SETSTATUS 3 "$(/usr/local/bin/d-sb-temp)" &
    $SETSTATUS 5 "$(/usr/local/bin/d-sb-memory)" &
    $SETSTATUS 6 "$(/usr/local/bin/d-sb-cpu)" &

    #if [ $((secs % 60)) = 0 ]; then
        #$SETSTATUS 5 "$(~/bin/statusbar/mouse_battery)" &
        #$SETSTATUS 1 "$(~/bin/statusbar/volume)" &
    #fi

    if [ $((secs % 3600)) = 0 ]; then
    	$SETSTATUS 4 "$(/usr/local/bin/d-sb-disk)" &
	$SETSTATUS 1 "$(/usr/local/bin/d-sb-updates)" &
	#$SETSTATUS 4 "$(~/bin/statusbar/sysupdates_paru)" &
    fi

    ((secs+=5))
    sleep 5
done
