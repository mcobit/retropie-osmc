#!/bin/bash

echo ""
echo "************************************"
echo "* Installation of Retropie on OSMC *"
echo "************************************"
echo ""
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!            DISCLAIMER             !"
echo "!  This script is provided *as is*  !"
echo "!  It may mess up your system or    !"
echo "!   kill your dog. You have been    !"
echo "!             warned!               !"
echo "!                                   !"
echo "!      Press Enter to continue      !"
echo "!      Press Ctrl + C to quit       !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
sleep 1
read

echo ""
echo "****************************"
echo "* Checking if you are root *"
echo "****************************"
echo ""
# check, if sudo is used
if [[ $(id -u) -ne 0 ]]; then
echo "Script must be run as root. Try 'sudo $0'"
exit 1
fi

echo ""
echo "**********************************"
echo "* Stopping KODI if it is running *"
echo "**********************************"
echo ""
sleep 1s
sudo service mediacenter stop
sleep 1s

echo ""
echo "**************************************************************"
echo "* Adding sources of Raspbian Jessie to the sources.list file *"
echo "**************************************************************"
echo ""
sleep 1s
sudo cp /etc/apt/sources.list /etc/apt/sources.bak
sudo echo "deb http://archive.raspbian.org/raspbian jessie main contrib non-free" >> /etc/apt/sources.list
sudo echo "deb-src http://archive.raspbian.org/raspbian jessie main contrib non-free" >> /etc/apt/sources.list

echo ""
echo "*******************************"
echo "* Instaling some dependencies *"
echo "*******************************"
echo ""
sleep 1s
#sudo apt-get update
#sudo apt-get -y install libts-dev git dialog

echo ""
echo "******************************"
echo "* Getting the Retropie scipt *"
echo "******************************"
echo ""
sleep 1s
cd /home/osmc
sudo rm -r RetroRie-Setup
git clone git://github.com/petrockblog/RetroPie-Setup.git
cd /home/osmc
sudo chown -R osmc RetroPie-Setup
sudo chgrp -R osmc RetroPie-Setup

# cp RetroPie-Setup/scriptmodules/admin/setup.sh RetroPie-Setup/scriptmodules/admin/setup.bak
# head -n -46 RetroPie-Setup/scriptmodules/admin/setup.sh > temp.txt ; mv temp.txt RetroPie-Setup/scriptmodules/admin/setup.sh
# cho "binaries_setup" >> RetroPie-Setup/scriptmodules/admin/setup.sh

echo ""
echo "**********************"
echo "* Running the script *"
echo "**********************"
echo ""
sleep 1s
cd /home/osmc/RetroPie-Setup
#chmod +x retropie_setup.sh
#sudo su osmc -c sudo ./retropie_setup.sh
scriptdir=/home/osmc/RetroPie-Setup
"$scriptdir/retropie_packages.sh" setup
# cp RetroPie-Setup/scriptmodules/admin/setup.bak RetroPie-Setup/scriptmodules/admin/setup.sh

echo ""
echo "********************************************************"
echo "* Removing some unneeded stuff and the stella emulator *"
echo "********************************************************"
echo ""
sleep 1s
sudo apt-get -y remove stella

sudo apt-get -y remove libboost1.55-dev

echo ""
echo "********************************"
echo "* Installing some useful stuff *"
echo "********************************"
echo ""
sleep 1s
sudo apt-get -y install libboost-system1.49 libboost-date-time1.49 libboost-filesystem1.49 libboost-locale1.49 libboost-thread1.49

wget http://malus.exotica.org.uk/~buzz/pi/sdl/sdl2/libsdl2_2.0.3_armhf.deb
wget http://malus.exotica.org.uk/~buzz/pi/sdl/sdl1/deb/rpi2/libsdl1.2debian_1.2.15-8rpi_armhf.deb

sudo dpkg -i libsdl*

echo ""
echo "*******************************"
echo "* Removing more useless stuff *"
echo "*******************************"
echo ""
sleep 1s
sudo apt-get -y remove libsdl1.2-dev libsdl-gfx1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev

echo ""
echo "********************************"
echo "* Installing more useful stuff *"
echo "********************************"
echo ""
sleep 1s
sudo apt-get -y install libjpeg8

echo ""
echo "***************"
echo "* Cleaning up *"
echo "***************"
echo ""
sleep 1s
sudo apt-get -y autoremove

echo ""
echo "****************"
echo " Last round... *"
echo "****************"
echo ""
sleep 1s
sudo apt-get install libsdl-mixer1.2 libsdl-image1.2 libsdl-net1.2 libsdl-gfx1.2 libsdl-sound1.2 libsdl-ttf2.0-0
echo ""
echo "**************************************************"
echo "* Remove unneeded repositories from sources.list *"
echo "**************************************************"
echo ""
sleep 1s
head -n -2 /etc/apt/sources.list > temp.txt ; mv temp.txt /etc/apt/sources.list

echo ""
echo "***************************************************************"
echo "* Finished. Say a prayer and then type: emulationstation      *"
echo "* If you want to update the binary packages, use this script! *"
echo "* Have fun!                                                   *"
echo "***************************************************************"

