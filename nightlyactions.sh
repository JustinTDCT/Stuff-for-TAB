#!/bin/bash
echo "$(date + "%Y-%d-%m")" >> /var/log/nightlyactions.log
echo "=============================================================" >> /var/log/nightlyactions.log
# clear out old files
echo "Removing old files ..." >> /var/log/nightlyactions.log
rm -r /etc/tab  2> /dev/null
rm -r /etc/tab_scripts 2> /dev/null
rm /home/tabadmin/SetupVeeamVM.sh 2> /dev/null
rm /home/tabadmin/SetIP.sh 2> /dev/null
rm /home/tabadmin/loginscript.sh 2> /dev/null
rm /bin/bouncelt.sh 2> /dev/null
rm /bin/bouncesc.sh 2> /dev/null
rm /bin/bouncescreencon.sh 2> /dev/null 
rm /bin/nightlyactions.sh 2> /dev/null
# make the tab folder
if [ ! -d "/etc/tab_scripts/" ]; then
  mkdir /etc/tab_scripts
fi
# grab new files
echo "Grab new files ..." >> /var/log/nightlyactions.log
wget -O /etc/tab_scripts/SetupVeeamVM.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/ref/heads/main/SetupVeeamVM 2> /dev/null
wget -O /etc/tab_scripts/SetIP.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/ref/heads/main/setip 2> /dev/null
wget -O /etc/tab_scripts/loginscript.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/ref/heads/main/loginscript 2> /dev/null
wget -O /etc/tab_scripts/DeployUbuntu.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/ref/heads/main/DeployUbuntu.sh 2> /dev/null
wget -O /etc/tab_scripts/disable-phased-update.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/ref/heads/main/disable-phased-update.sh 2> /dev/null
wget -O /bin/bouncelt.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/refs/heads/main/bouncelt.sh 2> /dev/null
wget -O /bin/bouncesc.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/refs/heads/main/bouncesc.sh 2> /dev/null
wget -O /bin/nightlyactions.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/refs/heads/main/nightlyactions.sh 2> /dev/null
# make them executable
chmod +xX /etc/tab_scripts/SetupVeeamVM.sh
chmod +xX /etc/tab_scripts/SetIP.sh
chmod +xX /etc/tab_scripts/loginscript.sh
chmod +xX /etc/tab_scripts/DeployUbuntu.sh
chmod +xX /etc/tab_scripts/disable-phased-update.sh
chmod +xX /bin/bouncelt.sh
chmod +xX /bin/bouncesc.sh
chmod +xX /bin/nightlyactions.sh
# update cron
echo "Updating cron ..." >> /var/log/nightlyactions.log
cat /etc/crontab >> /var/log/nightlyactions.log
sed '22,$ d' /etc/crontab > /tab_temp/crontab2
mv /tab_temp/crontab2 /etc/crontab
echo "30 20 * * * root /bin/nightlyactions.sh" >> /etc/crontab
cat /etc/crontab >> /var/log/nightlyactions.log
echo "Grab new files ..." >> /var/log/nightlyactions.log
# kill LT
echo "Restart LT (Check, kill, re-check) ..." >> /var/log/nightlyactions.log
service ltechagent status >> /var/log/nightlyactions.log
pkill -9 ltechagent
service ltechagent status >> /var/log/nightlyactions.log
# restart LT
/etc/init.d/ltechagent start
service ltechagent start
service ltechagent status >> /var/log/nightlyactions.log
# update the OS
echo "Update OS ..." >> /var/log/nightlyactions.log
apt update
apt upgrade -y
# check for reboot pending by file
echo "=============================================================" >> /var/log/nightlyactions.log
echo "Rebooting if needed ..." >> /var/log/nightlyactions.log
if [ -f var/run/reboot-required ]; then 
  echo "- Reboot required!" >> /var/log/nightlyactions.log
  shutdown -r now
fi
