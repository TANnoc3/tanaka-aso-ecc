#!/usr/bin/env bash
apt update
apt install -y unbound 

cat <<EOF > /etc/unbound/unbound.conf
server:
        verbosity: 3
        interface: 127.0.0.1
        interface: 192.0.2.53
        port: 53
        access-control: 192.0.2.53/24 allow
        access-control: ::1 allow
        include: "/etc/unbound/unbound.conf.d/*.conf"

forward-zone:
        name: "."
        forward-addr: 8.8.8.8
        forward-addr: 8.8.4.4
EOF

cat <<EOF > /etc/unbound/unbound.conf.d/zone.conf
private-domain: "aso-ecc"
local-data: "www.hoge.aso-ecc. IN A 192.0.2.254"
local-data: "hoge.aso-ecc. IN A 192.0.2.254"
local-data: "254.2.0.192.in-addr.arpa. PTR hoge.aso-ecc"
local-data: "254.2.0.192.in-addr.arpa. PTR www.hoge.aso-ecc"
local-zone: "*.aso-ecc." refuse
EOF

systemctl stop systemd-resolved 
systemctl disable systemd-resolved

echo 'nameserver 127.0.0.1' > /etc/resolv.conf

systemctl restart unbound
systemctl enable unbound
