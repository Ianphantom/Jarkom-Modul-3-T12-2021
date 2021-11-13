apt-get update -y
apt-get install nano -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.217.0.0/16
apt-get install isc-dhcp-relay -y
service isc-dhcp-relay restart