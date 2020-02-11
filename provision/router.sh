#!/usr/bin/env bash
INTERNAL_NW="10.0.0.0/24"
PUB_NW="192.0.2.0/24"
ROUTER_PUB_IP="192.0.2.254"
ROUTER_INTERNAL_IP="10.0.0.254"
WEB_INTERNAL_IP="10.0.0.80"
PUB_IF="enp0s8"
INTERNAL_IF="enp0s9"
HOSTONLY_IF="enp0s3"

apt install -y isc-dhcp-server

cat <<EOF > /etc/default/isc-dhcp-server
DHCPDv4_CONF=/etc/dhcp/dhcpd.conf
DHCPDv4_PID=/var/run/dhcpd.pid
INTERFACESv4="$INTERNAL_IF"
EOF

cat <<EOF > /etc/dhcp/dhcpd.conf
subnet 10.0.0.0 netmask 255.255.255.0 {
	range 10.0.0.10 10.0.0.30;
	option domain-name-servers 192.0.2.53;
	option routers 10.0.0.254;
}
EOF

dhcpd -cf /etc/dhcp/dhcpd.conf
# enable ip routing
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1' /etc/sysctl.conf

# NAT initialization
iptables --flush
# DNAT 
iptables -t nat -A PREROUTING -p tcp \
	--dst $ROUTER_PUB_IP --dport 80 -j DNAT \
	--to-destination $WEB_INTERNAL_IP
# MASQUERADE
iptables -t nat -A POSTROUTING -o $PUB_IF -d $PUB_NW -s $INTERNAL_NW -j MASQUERADE
iptables -t nat -A POSTROUTING -o $HOSTONLY_IF -s $INTERNAL_NW -j MASQUERADE

systemctl stop systemd-resolved 
systemctl disable systemd-resolved

echo 'nameserver 192.0.2.53' > /etc/resolv.conf
