#!/bin/bash
echo "version 1.10.08"
# make TAB's folder
mkdir /etc/tab
# create LT bounce script
echo "pkill -9 ltechagent;\ sudo /etc/init.d/ltechagent start" > /bin/bouncelt.sh
chmod +xX /bin/bouncelt.sh
# create screenconnect bounce script
echo "/etc/init.d/connectwisecontrol-24a22b9fc261d141 stop;\ /etc/init.d/connectwisecontrol-24a22b9fc261d141 start" > /bin/bouncescreencon.sh
chmod +xX /bin/bouncescreencon.sh
# install webmin
rm -f /usr/share/keyrings/webmin.gpg
curl -fsSL https://download.webmin.com/jcameron-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/webmin.gpg
repos=$(tail  /etc/apt/sources.list | grep -m 1 "webmin")
if [[ "$repos" != "deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge contrib" ]]; then
  echo "Adding WebMin to sources"
  echo "deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
fi
wget -O /etc/tab/DeployUbuntu.sh https://raw.githubusercontent.com/JustinTDCT/Stuff-for-TAB/main/DeployUbuntu.sh 2> /dev/null
chmod +xX /etc/tab/DeployUbuntu.sh
apt update
apt install webmin
# make motd
echo "TAB Computer Systems Ubunu Server" > /etc/motd
echo "====================================" >> /etc/motd
echo "- restart LabTech: sudo bouncelt.sh -or- sudo pkill -9 ltechagent; sudo /etc/init.d/ltechagent start" >> /etc/motd
echo "- restart Screen Connect: sudo /etc/init.d/connectwisecontrol-24a22b9fc261d141 stop; sudo /etc/init.d/connectwisecontrol-24a22b9fc261d141 start" >> /etc/motd
echo "- restart the server: sudo shutdown -r now" >> /etc/motd
echo "- access WebMin console: https://your_server_ip:10000" >> /etc/motd
echo "." >> /etc/motd
echo "." >> /etc/motd
echo "." >> /etc/motd
