#!/bin/bash

# VERSION 1.12 by mcobit


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
sudo su osmc -c "read"

echo ""
echo "****************************"
echo "* Checking if you are root *"
echo "****************************"
echo ""
# check, if sudo is used (taken and modified from RetroPie setup script)
if [ $(id -u) -ne 0 ]; then
echo "Script must be run as root. Try 'sudo $0'"
exit 1
fi

echo ""
echo "*********************************************"
echo "* Checking for newer version of this script *"
echo "*********************************************"
echo ""
sleep 1

wget -O script_temp https://raw.githubusercontent.com/mcobit/retropie-osmc/master/INSTALL_RETROPIE_ON_OSMC_RC.sh

VER1="$(head -n 3 INSTALL_RETROPIE_ON_OSMC_RC.sh)"
VER2="$(head -n 3 script_temp)"

if [ "$VER1" != "$VER2" ]; then
	sudo cp script_temp INSTALL_RETROPIE_ON_OSMC_RC.sh
	sudo chmod +x INSTALL_RETROPIE_ON_OSMC_RC.sh
	sudo chown osmc INSTALL_RETROPIE_ON_OSMC_RC.sh
	rm script_temp
	echo "Newer version detected and downloaded. Please restart the script!"
	exit
else
	echo "Script up to date."
	rm script_temp
fi

echo ""
echo "**********************************"
echo "* Stopping KODI if it is running *"
echo "**********************************"
echo ""
sleep 1s
sudo systemctl stop mediacenter
sleep 1s

echo ""
echo "**************************************************************"
echo "* Adding sources of Raspbian Jessie to the sources.list file *"
echo "**************************************************************"
echo ""
sleep 1s

sudo grep -v "raspbian" /etc/apt/sources.list > temp
sudo mv temp /etc/apt/sources.list
sudo cp /etc/apt/sources.list /etc/apt/sources.bak
sudo echo "deb http://archive.raspbian.org/raspbian jessie main contrib non-free" >> /etc/apt/sources.list

echo ""
echo "*******************************"
echo "* Installing some dependencies *"
echo "*******************************"
echo ""
sleep 1s
sudo apt-get update
sudo apt-get -y install libts-dev git dialog

echo ""
echo "******************************"
echo "* Getting the Retropie scipt *"
echo "******************************"
echo ""
sleep 1s
cd /home/osmc
sudo rm -r RetroPie-Setup
git clone git://github.com/petrockblog/RetroPie-Setup.git
cd /home/osmc
sudo chown -R osmc RetroPie-Setup
sudo chgrp -R osmc RetroPie-Setup

echo ""
echo "**********************"
echo "* Running the script *"
echo "**********************"
echo ""
sleep 1s
cd /home/osmc/RetroPie-Setup
scriptdir=/home/osmc/RetroPie-Setup
"$scriptdir/retropie_packages.sh" setup

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
sudo apt-get -y install libboost-system1.49.0 libboost-date-time1.49.0 libboost-filesystem1.49.0 libboost-locale1.49.0 libboost-thread1.49.0

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
sudo apt-get -y install libsdl-mixer1.2 libsdl-image1.2 libsdl-net1.2 libsdl-gfx1.2-5 libsdl-sound1.2 libsdl-ttf2.0-0 console-tools bash-completion libvncserver0

wget http://malus.exotica.org.uk/~buzz/pi/sdl/sdl1/deb/rpi2/libsdl1.2debian_1.2.15-8rpi_armhf.deb
wget http://malus.exotica.org.uk/~buzz/pi/sdl/sdl2/libsdl2_2.0.3_armhf.deb

sudo dpkg -i libsdl*

sudo apt-mark hold libsdl1.2debian
sudo apt-mark hold libsdl2

echo ""
echo "**************************************************"
echo "* Remove unneeded repositories from sources.list *"
echo "**************************************************"
echo ""
sleep 1s
sudo grep -v "raspbian" /etc/apt/sources.list > temp
sudo mv temp /etc/apt/sources.list

echo ""
echo "*****************************"
echo "* Installing custom scripts *"
echo "*****************************"
echo ""
cd /home/osmc
rm mediacenter retropie.sh retropie_watchdog.sh emulationstation

wget https://raw.githubusercontent.com/mcobit/retropie-osmc/master/retropie.sh
wget https://raw.githubusercontent.com/mcobit/retropie-osmc/master/retropie_watchdog.sh
wget https://raw.githubusercontent.com/mcobit/retropie-osmc/master/emulationstation

chmod +x emulationstation
chmod +x retropie_watchdog.sh
chmod +x retropie.sh
chown osmc emulationstation
chown osmc retropie.sh
chown osmc retropie_watchdog.sh

sudo cp emulationstation /usr/bin/
rm emulationstation

echo ""
echo "*************************************************************"
echo "* Would you like to create a menushortcut in the OSMC skin? *"
echo "* Press Y for yes and anything else for no.                             *"
echo "*************************************************************"
echo ""

read a
if [[ $a == "Y" || $a == "y" ]]; then
        echo "Installing shortcut if it doesn't exist already."

if [ ! "$(grep retropie.sh /home/osmc/.kodi/userdata/addon_data/script.skinshortcuts/mainmenu.DATA.xml)" ]; then

CONTENT='        <shortcut>\
                <defaultID />\
                <label>RetroPie</label>\
                <label2>Custom Shortcut</label2>\
                <icon>DefaultShortcut.png</icon>\
                <thumb />\
                <action>System.Exec(/home/osmc/retropie.sh)</action>\
        </shortcut>'

sed -i.bak '/<\/shortcuts>/i\'"$CONTENT" /home/osmc/.kodi/userdata/addon_data/script.skinshortcuts/mainmenu.DATA$

else

echo "Shortcut already created. Skipping..."

fi

fi

echo ""
echo "***************************************************************"
echo "* If you want a menuentry in KODI, make a custom shortcut     *"
echo "* with System.Exec(/home/osmc/retropie.sh)                    *"
echo "* The rest should be already done for you.                    *"
echo "***************************************************************"
echo ""
echo "***************************************************************"
echo "* Finished. Say a prayer and then type: emulationstation      *"
echo "* If you want to update the binary packages, use this script! *"
echo "* Have fun!                                                   *"
echo "***************************************************************"

