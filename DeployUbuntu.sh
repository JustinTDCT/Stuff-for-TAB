#!/bin/bash
# version 2.00.00

# check the userID variable, if you are not 0 you are not SUDO
echo "Checking to see if you are running under SUDO ..."
if [ $(id -u) -ne 0 ]; then 
  echo "- please run this as SUDO!"
  exit
else
  echo "- user is SUDO"
fi
# == old file handling
echo "Removing all old files as this script replaces and updates them ..."
rm -r /etc/tab  2> /dev/null
rm -r /etc/tab_scripts 2> /dev/null
rm -r /tab_temp
rm /home/tabadmin/SetupVeeamVM.sh 2> /dev/null
rm /home/tabadmin/SetIP.sh 2> /dev/null
rm /home/tabadmin/loginscript.sh 2> /dev/null
rm /bin/bouncelt.sh 2> /dev/null
rm /bin/bouncesc.sh 2> /dev/null
rm /bin/bouncescreencon.sh 2> /dev/null 
rm /bin/nightlyactions.sh 2> /dev/null
mkdir /etc/tab_scripts
mkdir /tab_temp
chmod +777 /tab_temp
# == grabbing new files (8 files)
echo "Grabbing updated files ..."
echo "- /etc/tab_scripts/SetupVeeam.sh"
wget -O /etc/tab_scripts/SetupVeeamVM.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/refs/heads/main/SetupVeeamVM 2> /dev/null
echo "- /etc/tab_scripts/SetIP.sh"
wget -O /etc/tab_scripts/SetIP.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/refs/heads/main/setip 2> /dev/null
echo "- /etc/tab_scripts/loginscript.sh"
wget -O /etc/tab_scripts/loginscript.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/refs/heads/main/loginscript 2> /dev/null
echo "- /etc/tab_scripts/DeployUbuntu.sh"
wget -O /etc/tab_scripts/DeployUbuntu.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/refs/heads/main/DeployUbuntu.sh 2> /dev/null
echo "- /etc/tab_scripts/disable-phased-update.sh"
wget -O /etc/tab_scripts/disable-phased-update.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/refs/heads/main/disable-phased-update.sh 2> /dev/null
echo "- /bin/bouncelt.sh"
wget -O /bin/bouncelt.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/refs/heads/main/bouncelt.sh 2> /dev/null
echo "- /bin/bouncesc.sh"
wget -O /bin/bouncesc.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/refs/heads/main/bouncesc.sh 2> /dev/null
echo "- /bin/nightlyactions.sh"
wget -O /bin/nightlyactions.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/refs/heads/main/nightlyactions.sh 2> /dev/null
# make the files executable (8 files)
chmod +xX /etc/tab_scripts/SetupVeeamVM.sh
chmod +xX /etc/tab_scripts/SetIP.sh
chmod +xX /etc/tab_scripts/loginscript.sh
chmod +xX /etc/tab_scripts/DeployUbuntu.sh
chmod +xX /etc/tab_scripts/disable-phased-update.sh
chmod +xX /bin/bouncelt.sh
chmod +xX /bin/bouncesc.sh
chmod +xX /bin/nightlyactions.sh
# create the nightly cron job to update files and the server
#echo "Adding CRONTAB job for ROOT to bounce LT nightly @ 8:00pm"
#sed '22,$ d' /etc/crontab > /tab_temp/crontab2
#mv /tab_temp/crontab2 /etc/crontab
#echo "30 20 * * * root /bin/nightlyactions.sh" >> /etc/crontab
# get IP of server
ip=$(ip -f inet -o addr show eth0|cut -d\  -f 7 | cut -d/ -f 1)
echo "Disabling phased updates ..."
sudo cat > /etc/apt/apt.conf.d/99-disable-phasing <<EOF
Update-Manager::Always-Include-Phased-Updates true;
APT::Get::Always-Include-Phased-Updates true;
EOF
# install webmin
echo "Installing WebMin ..."
rm -f /usr/share/keyrings/webmin.gpg
curl -fsSL https://download.webmin.com/jcameron-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/webmin.gpg
repos=$(tail  /etc/apt/sources.list | grep -m 1 "webmin")
if [[ "$repos" != "deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge contrib" ]]; then
  echo "Adding WebMin to sources"
  echo "deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
else
  echo "Repo already added, skipping"
fi
apt update
apt install webmin htop unzip bmon default-jre -y
# make motd
echo "Updating /etc/motd ..."
echo "TAB Computer Systems Ubunu Server" > /etc/motd
echo "====================================" >> /etc/motd
echo "- restart LabTech: sudo bouncelt.sh" >> /etc/motd
echo "- restart Screen Connect: sudo bouncescreencon.sh" >> /etc/motd
echo "- restart the server: sudo shutdown -r now" >> /etc/motd
echo "- access WebMin console: https://$ip:10000" >> /etc/motd
echo "- reset tabadmin password: passwd" >> /etc/motd
echo "-------------- VEEAM XFS SERVERS --------------" >> /etc/motd
echo "- expand LUN (assuming you expanded on NAS and rebooted VM): sudo xfs_growfs /dev/sdb" >> /etc/motd
echo "- check LUN space: df -H | grep /dev/sdb" >> /etc/motd
echo "- reset veeamuser password: sudo passwd veeamuser" >> /etc/motd
echo "- manually trim filesystem: sudo fstrim /mnt/veeamrepo" >> /etc/motd
echo "- fix LUN filesystem errors: sudo umount /dev/sdb; sudo xfs_repair /dev/sdb; sudo mount -a" >> /etc/motd
echo "." >> /etc/motd
echo "." >> /etc/motd
echo "." >> /etc/motd
cat /etc/motd
