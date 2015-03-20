#!/bin/bash
sudo openvt -c 8 -s -f clear
sudo openvt -c 8 -s -f echo "Running emulationstation from KODI"
sleep 2
while [ true ]; do
	VAR1="$(pgrep emulatio)"
		if [ ! "$VAR1" ]; then
			sudo openvt -c 8 -s -f clear
			sudo openvt -c 8 -s -f echo "Emulationstation quit... Starting KODI."
			sleep 1
			sudo openvt -c 8 -f clear
			sudo su -c "service mediacenter restart &" &
			sleep 1
			exit
		else
			sleep 2
fi
done
