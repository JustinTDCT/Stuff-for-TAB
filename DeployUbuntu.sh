#!/bin/bash
echo "TAB Ubuntu deployment script version 1.10.15"
# make TAB's folder
echo "- Creating tab folder in /etc"
mkdir /etc/tab
# create LT bounce script
echo "- Creating LT / ScreenConnect bounce scripts"
echo "pkill -9 ltechagent" > /bin/bouncelt.sh
echo "/etc/init.d/ltechagent start" >> /bin/bouncelt.sh
chmod +xX /bin/bouncelt.sh
# create screenconnect bounce script
echo "/etc/init.d/connectwisecontrol-24a22b9fc261d141 stop" > /bin/bouncescreencon.sh
echo "/etc/init.d/connectwisecontrol-24a22b9fc261d141 start" >> /bin/bouncescreencon.sh
chmod +xX /bin/bouncescreencon.sh
# add nightly LT bounce
echo "- Adding CRONTAB job for ROOT to bounce LT nightly"
lastline=$(tail /etc/crontab | grep -m 1 "bounce")
if [[ "$lastline" != *"bouncelt.sh"* ]]; then
  echo "30 2 * * * root /bin/bouncelt.sh" >> /etc/crontab
else
  echo "- CRONTAB exists, skipping"
fi
# ensure all our stuff is added
apt install -y bmon default-jre unzip 
# get IP of server
ip=$(ip -f inet -o addr show eth0|cut -d\  -f 7 | cut -d/ -f 1)
# install webmin
echo "- Installing WebMin"
rm -f /usr/share/keyrings/webmin.gpg
curl -fsSL https://download.webmin.com/jcameron-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/webmin.gpg
repos=$(tail  /etc/apt/sources.list | grep -m 1 "webmin")
if [[ "$repos" != "deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge contrib" ]]; then
  echo "Adding WebMin to sources"
  echo "deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
else
  echo "Repo already added, skipping"
fi
wget -O /etc/tab/DeployUbuntu.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/main/DeployUbuntu.sh 2> /dev/null
chmod +xX /etc/tab/DeployUbuntu.sh
apt update
apt install webmin htop unzip bmon default-jre -y
# make motd
echo "- Updating /etc/motd"
echo "TAB Computer Systems Ubunu Server" > /etc/motd
echo "====================================" >> /etc/motd
echo "- restart LabTech: sudo bouncelt.sh -or- sudo pkill -9 ltechagent; sudo /etc/init.d/ltechagent start" >> /etc/motd
echo "- restart Screen Connect: sudo bouncescreencon.sh -or- /etc/init.d/connectwisecontrol-24a22b9fc261d141 stop; sudo /etc/init.d/connectwisecontrol-24a22b9fc261d141 start" >> /etc/motd
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
tail /etc/motd
