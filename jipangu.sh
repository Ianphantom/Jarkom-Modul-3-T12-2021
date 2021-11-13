echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update -y
apt-get install nano -y
apt-get install isc-dhcp-server -y

echo "
INTERFACES=\"eth0\"
" > /etc/default/isc-dhcp-server

echo "
ddns-update-style none;

option domain-name \"example.org\";
option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

log-facility local7;

subnet 192.217.2.0 netmask 255.255.255.0{}

subnet 192.217.1.0 netmask 255.255.255.0 {
   range 192.217.1.20 192.217.1.99;
   range 192.217.1.150 192.217.1.169; 
   option routers 192.217.1.1;
   option broadcast-address 192.217.1.255;
   option domain-name-servers 192.217.2.2;
   default-lease-time 360;
   max-lease-time 7200;
}

subnet 192.217.3.0 netmask 255.255.255.0 {
   range 192.217.3.30 192.217.3.50; 
   option routers 192.217.3.1;
   option broadcast-address 192.217.3.255;
   option domain-name-servers 192.217.2.2;
   default-lease-time 720;
   max-lease-time 7200;
}

host Skypie {
    hardware ethernet de:d3:23:e1:5d:c1;
    fixed-address 192.217.3.69;
}
" > /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart