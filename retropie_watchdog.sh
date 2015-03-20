#!/bin/bash
sleep 2
echo "running"
while [ true ]; do
	VAR1="$(pgrep emulatio)"
		if [ ! "$VAR1" ]; then
			sleep 1
			sudo su -c "service mediacenter restart &" &
			sleep 1
			exit
		else
			sleep 2
fi
done
