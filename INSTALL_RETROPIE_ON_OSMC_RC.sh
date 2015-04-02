#!/bin/bash

# VERSION 2.06 by mcobit

#echo ""
#echo "************************************"
#echo "* Installation of Retropie on OSMC *"
#echo "************************************"
#echo ""
#echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
#echo "!            DISCLAIMER             !"
#echo "!  This script is provided *as is*  !"
#echo "!  It may mess up your system or    !"
#echo "!   kill your dog. You have been    !"
#echo "!             warned!               !"
#echo "!                                   !"
#echo "!      Press Enter to continue      !"
#echo "!      Press Ctrl + C to quit       !"
#echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
dialog --backtitle "RetroPie-OSMC setup script" --title "DISCLAIMER" --clear \
        --yesno "\nThis script is provided *as is*. It may mess up your system or kill your dog. You have been warned!\n\nDo you really want to continue?" 9 60

case $? in
  0)
    echo "Very well...";;
  1)
    echo "Aborted" && exit ;;
  255)
    echo "ESC pressed." && exit ;;
esac


#echo ""
#echo "****************************"
#echo "* Checking if you are root *"
#echo "****************************"
#echo ""
# check, if sudo is used (taken and modified from RetroPie setup script)
if [ $(id -u) -ne 0 ]; then
dialog --backtitle "RetroPie-OSMC setup script" --title "Checking if you are root" --infobox "\nScript must be run as root.\nTry 'sudo $0'" 6 60
#echo "Script must be run as root. Try 'sudo $0'"
exit 1
fi

#echo ""
#echo "*********************************************"
#echo "* Checking for newer version of this script *"
#echo "*********************************************"
#echo ""

wget -O script_temp https://raw.githubusercontent.com/mcobit/retropie-osmc/master/INSTALL_RETROPIE_ON_OSMC_RC.sh 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Checking for newer version of this script" --gauge "\nPlease wait...\n"  7 60 0
sleep 2

 
VER1="$(head -n 3 INSTALL_RETROPIE_ON_OSMC_RC.sh)"
VER2="$(head -n 3 script_temp)"

if [ "$VER1" != "$VER2" ]; then
	sudo cp script_temp INSTALL_RETROPIE_ON_OSMC_RC.sh
	sudo chmod +x INSTALL_RETROPIE_ON_OSMC_RC.sh
	sudo chown osmc INSTALL_RETROPIE_ON_OSMC_RC.sh
	rm script_temp
	dialog --backtitle "RetroPie-OSMC setup script" --title "Checking for newer version of this script" --infobox "\nNewer version detected and downloaded\nPlease restart the script with\n'sudo $0'\n" 7 60
	#echo "Newer version detected and downloaded. Please restart the script!"
	exit
else
	dialog --backtitle "RetroPie-OSMC setup script" --title "Checking for newer version of this script" --pause "\nScript up to date. Continuing...\n" 9 60 2
	#echo "Script up to date."
	rm script_temp
fi

#echo ""
#echo "**********************************"
#echo "* Stopping KODI if it is running *"
#echo "**********************************"
#echo ""
#sleep 1s
sudo systemctl stop mediacenter | dialog --backtitle "RetroPie-OSMC setup script" --title "Stopping Kodi if it is running" --pause "\nKodi stopped.\n" 9 60 2

#echo ""
#echo "**************************************************************"
#echo "* Adding sources of Raspbian Jessie to the sources.list file *"
#echo "**************************************************************"
#echo ""
#sleep 1s

sudo cp /etc/apt/sources.list /etc/apt/sources.bak
sudo grep -v "raspbian" /etc/apt/sources.list > temp
sudo mv temp /etc/apt/sources.list
sudo echo "deb http://archive.raspbian.org/raspbian jessie main contrib non-free" >> /etc/apt/sources.list

dialog --backtitle "RetroPie-OSMC setup script" --title "Adding sources of Raspbian Jessie to sources.list file" --pause "\nSources added.\n" 9 60 2

#echo ""
#echo "*******************************"
#echo "* Installing some dependencies *"
#echo "*******************************"
#echo ""
#sleep 1s
sudo apt-mark unhold libsdl1.2debian libsdl2 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --backtitle "RetroPie-OSMC setup script" --title "Unmarking Dispmanx SDL libraries for hold" --infobox "\nPlease wait...\n" 5 50
sudo apt-get remove stella libsdl1.2-dev libsdl2-2.0-0 | dialog  --backtitle "RetroPie-OSMC setup script" --title "Remove old SDL2" --gauge "\nPlease wait...\n"  7 60
sudo dpkg --configure -a
sudo apt-get -y -f install | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog  --backtitle "RetroPie-OSMC setup script" --title "Checking database" --gauge "\nPlease wait...\n"  7 60
sudo apt-get update 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" 2>&1 | dialog --backtitle "RetroPie-OSMC setup script" --title "Updating package database..." --infobox "\nPlease wait...\n"  5 60
sudo apt-get -y --show-progress install libts-dev git dialog | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog  --backtitle "RetroPie-OSMC setup script" --title "Installing dependencies" --gauge "\nPlease wait...\n"  7 60
sudo apt-get --show-progress -y install libxinerama1 libboost-system1.49.0 libboost-date-time1.49.0 libboost-filesystem1.49.0 libboost-locale1.49.0 libboost-thread1.49.0 libjpeg8 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog  --backtitle "RetroPie-OSMC setup script" --title "Installing stuff" --gauge "\nPlease wait...\n"  7 60
sudo apt-get --show-progress -y install libxcursor1 libxrandr2 libxss1 libxxf86vm1 libglu1-mesa libudev0 libsdl-mixer1.2 libsdl-image1.2 libsdl-net1.2 libsdl-gfx1.2-5 libsdl-sound1.2 libsdl-ttf2.0-0 console-tools bash-completion libvncserver0 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog  --backtitle "RetroPie-OSMC setup script" --title "Install more stuff" --gauge "\nPlease wait...\n"  7 60
sudo apt-get --show-progress -y install libfreeimage3 libtheora0 libfaad2 libmpeg2-4 freepats libboost-serialization1.49.0 libarchive13 libportaudio0 libportaudio2 libzip2 libvpx1 timidity libaudiofile1 libgcrypt20 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog  --backtitle "RetroPie-OSMC setup script" --title "Install even more stuff" --gauge "\nPlease wait...\n"  7 60
sudo ln -s /usr/lib/arm-linux-gnueabihf/libarchive.so.13.1.2 /usr/lib/arm-linux-gnueabihf/libarchive.so.12
#echo ""
#echo "******************************"
#echo "* Getting the Retropie scipt *"
#echo "******************************"
#echo ""
#sleep 1s
cd /home/osmc
sudo rm -r RetroPie-Setup
git clone --progress git://github.com/petrockblog/RetroPie-Setup.git 2>&1 | grep -oP --line-buffered "(\d+(\.\d+)?(?=%))"  | dialog  --backtitle "RetroPie-OSMC setup script" --title "Getting the RetroPie Setup script" --gauge "\nCloning git repo\n"  7 60
cd /home/osmc
sudo chown -R osmc RetroPie-Setup
sudo chgrp -R osmc RetroPie-Setup
#echo ""
#echo "**********************"
#echo "* Running the script *"
#echo "**********************"
#echo ""
#sleep 1s
cd /home/osmc/RetroPie-Setup
sed -i '/already/d' scriptmodules/emulators/vice.sh
sed -i '/depends_/,/}/d' scriptmodules/libretrocores/*
sed -i '/depends_/,/}/d' scriptmodules/supplementary/*
sed -i '/depends_/,/}/d' scriptmodules/ports/*
sed -i '/depends_/,/}/d' scriptmodules/emulators/*
scriptdir=/home/osmc/RetroPie-Setup
"$scriptdir/retropie_packages.sh" setup

#echo ""
#echo "********************************************************"
#echo "* Removing some unneeded stuff and the stella emulator *"
#echo "********************************************************"
#echo ""
#sleep 1s
sudo apt-get -y --show-progress remove libsdl2-2.0-0 stella libsdl1.2-dev | dialog  --backtitle "RetroPie-OSMC setup script" --title "Remove old SDL2" --gauge "\nPlease wait...\n"  7 60
sudo apt-get -f -y --show-progress install | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog  --backtitle "RetroPie-OSMC setup script" --title "Fixing broken stuff" --gauge "\nPlease wait...\n"  7 60

#echo ""
#echo "*******************************"
#echo "* Removing more useless stuff *"
#echo "*******************************"
#echo ""
#sleep 1s
sudo apt-get --show-progress -y remove libsdl1.2-dev libsdl-gfx1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog  --backtitle "RetroPie-OSMC setup script" --title "Uninstalling more useless stuff" --gauge "\nPlease wait...\n"  7 60

#echo ""
#echo "***************"
#echo "* Cleaning up *"
#echo "***************"
#echo ""
#sleep 1s
sudo apt-get --show-progress -y autoremove | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog  --backtitle "RetroPie-OSMC setup script" --title "Cleaning up" --gauge "\nPlease wait...\n"  7 60

#echo ""
#echo "****************************"
#echo " Dispmanx SDL libraries... *"
#echo "****************************"
#echo ""
#sleep 1s

wget http://malus.exotica.org.uk/~buzz/pi/sdl/sdl1/deb/rpi2/libsdl1.2debian_1.2.15-8rpi_armhf.deb 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading Dispmanx SDL 1.2 " --gauge "\nPlease wait...\n"  7 60
wget http://malus.exotica.org.uk/~buzz/pi/sdl/sdl2/libsdl2_2.0.3_armhf.deb 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading Dispmanx SDL 2" --gauge "\nPlease wait...\n"  7 60

sudo dpkg -i libsdl* 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --backtitle "RetroPie-OSMC setup script" --title "Installing Dispmanx SDL libraries" --infobox "\nPlease wait...\n" 5 50

sudo apt-mark hold libsdl1.2debian libsdl2 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --backtitle "RetroPie-OSMC setup script" --title "Marking Dispmanx SDL libraries for hold" --infobox "\nPlease wait...\n" 5 50

#echo ""
#echo "**************************************************"
#echo "* Remove unneeded repositories from sources.list *"
#echo "**************************************************"
#echo ""
#sleep 1s
sudo grep -v "raspbian" /etc/apt/sources.list > temp
sudo mv temp /etc/apt/sources.list
dialog --backtitle "RetroPie-OSMC setup script" --title "Removing unneeded sources from sources.list" --pause "\nSources removed.\n" 9 60 2
sudo cp /etc/apt/sources.bak /etc/apt/sources.list
sudo apt-get update 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" 2>&1 | dialog --backtitle "RetroPie-OSMC setup script" --title "Updating package database to revert changes" --infobox "\nPlease wait\n"  5 60

#echo ""
#echo "*****************************"
#echo "* Installing custom scripts *"
#echo "*****************************"
#echo ""
cd /home/osmc
rm retropie.sh retropie_watchdog.sh emulationstation

wget https://raw.githubusercontent.com/mcobit/retropie-osmc/master/retropie.sh 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading retropie.sh script" --gauge "\nPlease wait...\n"  7 60
wget https://raw.githubusercontent.com/mcobit/retropie-osmc/master/retropie_watchdog.sh 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading retropie_watchdog.sh script" --gauge "\nPlease wait...\n"  7 60
wget https://raw.githubusercontent.com/mcobit/retropie-osmc/master/emulationstation 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading emulationstation script" --gauge "\nPlease wait...\n"  7 60

chmod +x emulationstation
chmod +x retropie_watchdog.sh
chmod +x retropie.sh
chown osmc emulationstation
chown osmc retropie.sh
chown osmc retropie_watchdog.sh

sudo cp emulationstation /usr/bin/
rm emulationstation

dialog --backtitle "RetroPie-OSMC setup script" --title "Setting up scripts" --pause "\nAll done.\n" 9 60 2

#echo ""
#echo "*************************************************************"
#echo "* Would you like to create a menushortcut in the OSMC skin? *"
#echo "* Press Y for yes and anything else for no.                 *"
#echo "*************************************************************"
#echo ""

#read a
#        echo "Installing shortcut if it doesn't exist already."

dialog --backtitle "RetroPie-OSMC setup script" --title "Creating shortcut" --clear \
        --yesno "\nThe script can create a menushortcut in KODI.\nWould you like to do so?\n" 9 60

case $? in
  0)
#   "Very well..." 
    if [ ! "$(grep retropie.sh /home/osmc/.kodi/userdata/addon_data/script.skinshortcuts/mainmenu.DATA.xml)" ]; then

CONTENT='        <shortcut>\
                <defaultID />\
                <label>RetroPie</label>\
                <label2>Custom Shortcut</label2>\
                <icon>DefaultShortcut.png</icon>\
                <thumb />\
                <action>System.Exec(/home/osmc/retropie.sh)</action>\
        </shortcut>'

sed -i.bak '/<\/shortcuts>/i\'"$CONTENT" /home/osmc/.kodi/userdata/addon_data/script.skinshortcuts/mainmenu.DATA.xml

dialog --backtitle "RetroPie-OSMC setup script" --title "Creating shortcut" --pause "\nShortcut created.\n" 9 60 2

else

dialog --backtitle "RetroPie-OSMC setup script" --title "Creating shortcut" --pause "\nShortcut already exists.\n" 9 60 2

fi
;;
  1)
    dialog --backtitle "RetroPie-OSMC setup script" --title "Creating shortcut" --pause "\nNot creating shortcut\n" 9 60 2 
;;
  255)
    dialog --backtitle "RetroPie-OSMC setup script" --title "Creating shortcut" --pause "\nNot creating shortcut.\n" 9 60 2
;;
esac

dialog --backtitle "RetroPie-OSMC setup script" --title "FINISHED!" --pause "\nEnjoy RetroPie on your OSMC installation!\n\nTo update the Binaries or the script, simply rerun this script." 12 60 2
#echo ""
#echo "***************************************************************"
#echo "* If you want a menuentry in KODI, make a custom shortcut     *"
#echo "* with System.Exec(/home/osmc/retropie.sh)                    *"
#echo "* The rest should be already done for you.                    *"
#echo "***************************************************************"
#echo ""
#echo "***************************************************************"
#echo "* Finished. Say a prayer and then type: emulationstation      *"
#echo "* If you want to update the binary packages, use this script! *"
#echo "* Have fun!                                                   *"
#echo "***************************************************************"
