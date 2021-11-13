echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update -y
apt-get install nano -y
apt-get install squid -y
mv /etc/squid/squid.conf /etc/squid/squid.conf.bak

echo "
include /etc/squid/acl.conf
http_port 5000
visible_hostname Water7

dns_nameservers 192.217.2.2
acl badsites dstdomain google.com
deny_info http://super.franky.t12.com/ badsites
deny_info ERR_ACCESS_DENIED all
http_reply_access deny badsites

auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 5
auth_param basic realm Proxy
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive on
acl USERS proxy_auth REQUIRED
http_access allow USERS

http_access allow AVAILABLE_WORKING
http_access deny all

acl multimedia url_regex -i \.png$ \.jpg$
acl bar proxy_auth luffybelikapalt12
delay_pools 1
delay_class 1 1
delay_parameters 1 1250/6400
delay_access 1 allow multimedia bar
delay_access 1 deny ALL
http_access deny ALL

acl multimedia url_regex -i \.png$ \.jpg$
acl bar proxy_auth luffybelikapalt12
delay_pools 1
delay_class 1 1
delay_parameters 1 1250/6400
delay_access 1 allow multimedia bar
delay_access 1 deny ALL
http_access deny ALL

" > /etc/squid/squid.conf

echo "
acl AVAILABLE_WORKING time MTWH 07:00-11:00
acl AVAILABLE_WORKING time TWHF 17:00-23:59
acl AVAILABLE_WORKING time A    00:00-03:00
" >/etc/squid/acl.conf

apt-get install apache2-utils -y
htpasswd -b -c /etc/squid/passwd luffybelikapalt12 luffy_t12 
htpasswd -b /etc/squid/passwd zorobelikapalt12 zoro_t12

service squid restart