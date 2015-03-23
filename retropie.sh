#!/bin/bash
# This scripts starts the emulationstation watchdog deamon and
# emulationstation itself while stopping KODI afterwards.
# Script by mcobit

sudo su -c "nohup service mediacenter stop &" &

sudo openvt -c 7 -s -f clear
sudo openvt -c 7 -s -f echo "Running emulationstation from KODI"

sudo su osmc -c "sh /home/osmc/retropie_watchdog.sh &" &
sudo su osmc -c "nohup openvt -c 7 -f -s emulationstation &" &
sleep 3
sudo openvt -c 7 -s -f clear

exit
