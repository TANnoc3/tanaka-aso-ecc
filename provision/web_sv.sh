#!/usr/bin/env bash

apt update
apt install -y nginx

if [ ! -d /data ]; then
	mkdir /data 
fi

cat <<EOF > /data/index.html
     _
   _| |
 _| | |
| | | |
| | | | __
| | | |/  \
|       /\ \  OK!!!
|      /  \/
|      \  /\
|       \/ /
 \        /
  |     /
  |    |
EOF

cat <<EOF > /etc/nginx/nginx.conf
events {
	worker_connections  1024;
}

http {
	server {
		listen 80;
		location / {
			root /data;
			index index.html;
		}
		charset UTF-8;
		access_log /var/log/nginx/access_log;
		error_log /var/log/nginx/error_log;
	}
}
EOF

systemctl restart nginx

ip route del default
ip route add default via 10.0.0.254

systemctl stop systemd-resolved 
systemctl disable systemd-resolved

echo 'nameserver 192.0.2.53' > /etc/resolv.conf
