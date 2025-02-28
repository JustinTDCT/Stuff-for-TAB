#!/bin/bash
echo "pkill -9 ltechagent" > /bin/bouncelt.sh
echo "/etc/init.d/ltechagent start" >> /bin/bouncelt.sh
chmod +xX /bin/bouncelt.sh
