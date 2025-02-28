#!/bin/bash
sudo cat > /etc/apt/apt.conf.d/99-disable-phasing <<EOF
Update-Manager::Always-Include-Phased-Updates true;
APT::Get::Always-Include-Phased-Updates true;
EOF
