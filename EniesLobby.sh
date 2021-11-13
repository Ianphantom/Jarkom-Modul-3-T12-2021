echo "nameserver 192.168.122.1" >/etc/resolv.conf
apt-get update -y
apt-get install nano -y
apt-get install bind9 -y
apt-get install lynx -y

echo "
options {
        directory \"/var/cache/bind\";
        forwarders {
                192.168.122.1;
        };
        allow-query{any;};
        auth-nxdomain no;
        listen-on-v6 { any; };
};

" > /etc/bind/named.conf.options

echo "
zone \"jualbelikapal.t12.com\" {
        type master;
        file \"/etc/bind/jarkom/jualbelikapal.t12.com\";
};

zone \"franky.t12.com\" {
        type master;
        file \"/etc/bind/jarkom/franky.t12.com\";
};
"> /etc/bind/named.conf.local

mkdir -p  /etc/bind/jarkom

echo "
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     franky.t12.com. root.franky.t12.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      franky.t12.com.
@               IN      A       192.217.3.69
www             IN      CNAME   franky.t12.com.
super           IN      A       192.217.3.69
www.super       IN      CNAME   super.franky.t12.com.
" > /etc/bind/jarkom/franky.t12.com

echo "
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     jualbelikapal.t12.com. root.jualbelikapal.t12.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      jualbelikapal.t12.com.
@       IN      A       192.217.2.3

" > /etc/bind/jarkom/jualbelikapal.t12.com

service bind9 restart