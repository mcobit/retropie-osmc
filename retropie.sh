#!/bin/bash
# This scripts starts the emulationstation watchdog deamon and
# emulationstation itself while stopping KODI afterwards.
# Script by mcobit

sudo openvt -c 7 -s -f clear
sudo openvt -c 7 -s -f echo "Running emulationstation from KODI"
sleep 2
sudo su osmc -c "sh /home/osmc/retropie_watchdog.sh &" &
sudo su osmc -c "nohup openvt -c 7 -f -s emulationstation &" &
sleep 2
sudo openvt -c 7 -s -f clear

sudo su -c "systemctl stop mediacenter &" &

exit
