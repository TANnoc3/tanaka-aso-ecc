#!/usr/bin/env bash
apt install -y curl 

systemctl stop systemd-resolved 
systemctl disable systemd-resolved

echo 'nameserver 192.0.2.53' > /etc/resolv.conf
