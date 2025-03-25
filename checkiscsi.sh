#!/bin/bash  
# version 1.10.02
if [ -f /home/tabadmin/script_runs.cfg ]; then
  echo "reboot"
fi
if [ -f /mnt/veeamrepo/backups/ ]; then
  echo "nothing"
else
  echo "touch file"
fi
