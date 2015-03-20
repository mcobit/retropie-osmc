#!/bin/bash

touch /home/osmc/retropie_start
sudo su -c "nohup service mediacenter stop &" &
sleep 10

