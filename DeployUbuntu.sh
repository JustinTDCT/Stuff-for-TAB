#!/bin/bash
# make TAB's folder
mkdir /etc/tab
# create LT bounce script
echo “pkill -9 ltechagent; sudo /etc/init.d/ltechagent start” > /bin/bouncelt.sh
chmod +xX /bin/bouncelt.sh
# create screenconnect bounce script
echo “/etc/init.d/connectwisecontrol-24a22b9fc261d141 stop; /etc/init.d/connectwisecontrol-24a22b9fc261d141 start” > /bin/bouncescreencon.sh
chmod +xX /bin/bouncescreencon.sh
