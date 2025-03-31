#!/bin/bash  
# version 1.02.0
if [[ "$HOSTNAME" == *"veeam"* ]]; then
  echo "Veeam server moving ahead."
else
  exit
fi
if [ -d /mnt/veeamrepo/backups/ ]; then
  echo "iSCSI OK"
  if [ -f /etc/tab_scripts/iscsi.fail ]; then
    echo "Removing old fail file..."
    echo "$(date)" >> /var/log/nightlyactions.log
    echo "- iSCSI reconnected" > /var/log/nightlyactions.log
    rm -f /etc/tab_scripts/iscsi.fail
  fi
else
  if [ -f /etc/tab_scripts/iscsi.fail ]; then
    echo "2nd fail, rebooting..."
    echo "Removing old fail file..."
    rm -f /etc/tab_scripts/iscsi.fail
    echo "$(date)" >> /var/log/nightlyactions.log
    echo "- 2nd fail, rebooting" > /var/log/nightlyactions.log
    shutdown -r now
  else  
    echo "iSCSI fail - dropping file..."
    touch /etc/tab_scripts/iscsi.fail
    echo "$(date)" >> /var/log/nightlyactions.log
    echo "- 1st fail, dropping file" > /var/log/nightlyactions.log
  fi
fi
