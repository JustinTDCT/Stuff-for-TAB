#!/bin/bash
# clear out old files
rm -r /etc/tab  2> /dev/null
rm -r /etc/tab_scripts 2> /dev/null
rm /home/tabadmin/SetupVeeamVM.sh 2> /dev/null
rm /home/tabadmin/SetIP.sh 2> /dev/null
rm /home/tabadmin/loginscript.sh 2> /dev/null
rm /bin/bouncelt.sh 2> /dev/null
rm /bin/bouncesc.sh 2> /dev/null
rm /bin/bouncescreencon.sh 2> /dev/null 
# make the tab folder
if [ ! -d "/etc/tab_scripts/" ]; then
  mkdir /etc/tab_scripts
fi
# grab new files
wget -O /etc/tab_scripts/SetupVeeamVM.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/main/SetupVeeamVM 2> /dev/null
wget -O /etc/tab_scripts/SetIP.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/main/setip 2> /dev/null
wget -O /etc/tab_scripts/loginscript.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/main/loginscript 2> /dev/null
wget -O /etc/tab_scripts/DeployUbuntu.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/main/DeployUbuntu.sh 2> /dev/null
wget -O /etc/tab_scripts/disable-phased-update.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/main/disable-phased-update.sh 2> /dev/null
wget -O /bin/bouncelt.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/main/bouncelt.sh 2> /dev/null
wget -O /bin/bouncesc.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/main/bouncesc.sh 2> /dev/null
wget -O /bin/nightlyactions.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/main/nightlyactions.sh 2> /dev/null
# make them executable
chmod +xX /etc/tab_scripts/SetupVeeamVM.sh
chmod +xX /etc/tab_scripts/SetIP.sh
chmod +xX /etc/tab_scripts/loginscript.sh
chmod +xX /etc/tab_scripts/DeployUbuntu.sh
chmod +xX /etc/tab_scripts/disable-phased-update.sh
chmod +xX /bin/bouncelt.sh
chmod +xX /bin/bouncesc.sh
chmod +xX /bin/nightlyactions.sh
# kill LT
pkill -9 ltechagent
# restart LT
/etc/init.d/ltechagent start
# update the OS
apt update
apt upgrade -y
# check for reboot pending by file
if [ -f var/run/reboot-required ]; then 
  shutdown -r now
fi
