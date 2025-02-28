#!/bin/bash
pkill -9 ltechagent
/etc/init.d/ltechagent start
apt update
apt upgrade -y
