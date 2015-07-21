# retropie-osmc
This is a simple script to install retropie alongside osmc.

To use it please ssh into the pi or get on a commandline as user osmc.
I only tested this on PI 2. It might work on the 1 but I am not sure.

You need to stop Kodi before running emulationstation as the input will be grabbed by kodi otherwise.

Note: Everything you do with this is on your own risk!

On a shell go to the osmc home directory:

cd /home/osmc

Download the script:

wget https://raw.githubusercontent.com/jypy/retropie-osmc/master/INSTALL_RETROPIE_ON_OSMC_RC.sh

Run the script:

chmod +x INSTALL_RETROPIE_ON_OSMC_RC.sh
sudo ./INSTALL_RETROPIE_ON_OSMC_RC.sh

Wait a long time and pray.

If you see the dialog of the RetroPie-Setup script,
choose binary installation!!!

If you see it again, ignore uninstallable packages and select cancel afterwards. The rest of the script will continue.

If you want a launcher in KODI, you have to setup a custom menu shortcut with "System.Exec(/home/osmc/retropie.sh)".
the custom mediacenter script should already be in place.

If you exit emulationstation when you started from the script, you should be back in KODI again.

Good luck!
