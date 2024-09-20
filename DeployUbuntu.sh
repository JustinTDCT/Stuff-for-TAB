#!/bin/bash
# make TAB's folder
mkdir /etc/tab
# create LT bounce script
echo “pkill -9 ltechagent; sudo /etc/init.d/ltechagent start” > /bin/bouncelt.sh
chmod +xX /bin/bouncelt.sh
# create screenconnect bounce script
echo “/etc/init.d/connectwisecontrol-24a22b9fc261d141 stop; /etc/init.d/connectwisecontrol-24a22b9fc261d141 start” > /bin/bouncescreencon.sh
chmod +xX /bin/bouncescreencon.sh
# install webmin
curl -fsSL https://download.webmin.com/jcameron-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/webmin.gpg
echo "deb [signed-by=/usr/share/keyrings/webmin.gpg] http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
apt update
apt install webmin
# make motd
echo "TAB Computer Systems Ubunu Server" > /etc/motd
echo "====================================" >> /etc/motd
echo "- restart LabTech: sudo bouncelt.sh -or- sudo pkill -9 ltechagent; sudo /etc/init.d/ltechagent start" >> /etc/motd
echo "- restart Screen Connect: sudo /etc/init.d/connectwisecontrol-24a22b9fc261d141 stop; sudo /etc/init.d/connectwisecontrol-24a22b9fc261d141 start" >> /etc/motd
echo "- restart the server: sudo shutdown -r now" >> /etc/motd
echo "- access WebMin console: https://your_server_ip:10000" >> /etc/motd
