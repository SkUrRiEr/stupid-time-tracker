#!/bin/bash

DB=$(dirname "$0")"/db.csv"

function usage() {
	echo $0 "action [task]"
	echo "where action is one of:"
	echo " - start - starts a task"
	echo " - stop - ends the running task"
	echo " - pause - pauses the current task to work on another"
	echo " - continue - continues the last paused task"
	echo

	exit 1;
}

if [ "x$1" = "x" ]; then
	echo "ERROR: No action specified!";

	usage;
fi

case "$1" in
	start)
		if [ "x$2" = "x" ]; then
			echo "ERROR: No task specified!"

			usage;
		fi
	;;
	stop) ;;
	*)
		echo "ERROR: Invalid command!"

		usage;
	;;
esac

if ! [ -f "$DB" ]; then
	echo "time,action,task" > "$DB"
fi

CURRENTTASK=$(tail -n 1 "$DB" | grep -F ",start," | sed 's/^"[^"]*",start,"\(.*\)"$/\1/')

echo "Current task is $CURRENTTASK";

case $1 in
	start)
		if [ "x$CURRENTTASK" = "x$2" ]; then
			exit;
		fi

		if ! [ "x$CURRENTTASK" = "x" ]; then
			$0 stop
		fi

		echo "\""$(date +"%a, %d %b %Y %T %z")"\",start,\"$2\"" >> $DB
	;;
	stop)
		if [ "x$CURRENTTASK" = "x" ]; then
			exit
		fi

		echo "\""$(date +"%a, %d %b %Y %T %z")"\",end,\"$CURRENTTASK\"" >> $DB
	;;
esac
