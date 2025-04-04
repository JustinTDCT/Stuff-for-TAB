#!/bin/bash  
# version 1.03.3
if [[ "$HOSTNAME" == *"veeam"* ]]; then
  echo "Veeam server moving ahead."
else
  exit
fi
if [ -d /mnt/veeamrepo/backups/ ]; then
  echo "iSCSI OK"
  if [ -f /etc/tab_scripts/iscsi.fail ]; then
    echo "Removing old fail file..."
    echo "$(date)" >> /var/log/checkiscsi.log
    echo "- iSCSI reconnected" >> /var/log/checkiscsi.log
    rm -f /etc/tab_scripts/iscsi.fail
  fi
else
  if [ -f /etc/tab_scripts/iscsi.fail ]; then
    echo "2nd fail, rebooting..."
    echo "Removing old fail file..."
    rm -f /etc/tab_scripts/iscsi.fail
    echo "$(date)" >> /var/log/checkiscsi.log
    echo "- 2nd fail, rebooting" >> /var/log/checkiscsi.log
    shutdown -r now
  else  
    echo "iSCSI fail - dropping file..."
    touch /etc/tab_scripts/iscsi.fail
    echo "$(date)" >> /var/log/checkiscsi.log
    echo "- 1st fail, dropping file" >> /var/log/checkiscsi.log
  fi
fi
