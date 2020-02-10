#!/usr/bin/env bash
apt install -y curl isc-dhcp-client
ip route del default dev enp0s3
ip route add default dev enp0s8 via 10.0.0.254

systemctl stop systemd-resolved 
systemctl disable systemd-resolved

echo 'nameserver 192.0.2.53' > /etc/resolv.conf
