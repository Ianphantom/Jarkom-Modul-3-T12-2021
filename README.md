# Jarkom-Modul-3-T12-2021

Nama Kelompok :  
- Ian Felix Jonathan Simanjuntak
- Muhammad Zakky Ghufron
- Muhammad Naufal Imantyasto

### Gambar Topologi
![image](https://user-images.githubusercontent.com/50267676/141628788-d83842a9-69af-40f9-ad40-1b98899b6788.png)

### Nomor 1
Luffy bersama Zoro berencana membuat peta tersebut dengan kriteria EniesLobby sebagai DNS Server, Jipangu sebagai DHCP Server, Water7 sebagai Proxy Server

### Jawaban Nomor 1
Untuk soal nomor 1 akan dijelaskan selagi kami mengerjakan soal soal berikutnya

### Nomor 2
dan Foosha sebagai DHCP Relay (2)

### Jawaban Nomor 2
Pada Foosha, kami menjalankan beberapa perintah sebagai berikut
```bash
apt-get update -y
apt-get install nano -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.217.0.0/16
apt-get install isc-dhcp-relay -y
service isc-dhcp-relay restart
```
Dari perintah diatas kami pertama sekali melakukan update, lalu menjalankan IPTABLES. Setelah menjalankan IPTABLES kami melakukan download isc-dhcp-relay. Ketika melakukan download dhcp-relay, kami menjadikan Jipangu (192.217.2.4) sebagai dhcp-server dan interfaces yang kami gunakan adalah `eth1 eth2 eth3` seperti gambar dibawah ini

![image](https://user-images.githubusercontent.com/50267676/141637521-8923463f-741c-4139-bbbe-1cf457905f49.png)

### Nomor 3 4 5 6
Ada beberapa kriteria yang ingin dibuat oleh Luffy dan Zoro, yaitu:
- Semua client yang ada HARUS menggunakan konfigurasi IP dari DHCP Server.
- Client yang melalui Switch1 mendapatkan range IP dari [prefix IP].1.20 - [prefix IP].1.99 dan [prefix IP].1.150 - [prefix IP].1.169 (3)
- Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.30 - [prefix IP].3.50 (4)
- Client mendapatkan DNS dari EniesLobby dan client dapat terhubung dengan internet melalui DNS tersebut. (5)
- Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch1 selama 6 menit sedangkan pada client yang melalui Switch3 selama 12 menit. Dengan waktu maksimal yang dialokasikan untuk peminjaman alamat IP selama 120 menit. (6)

### Jawaban Nomor 3 4 5 6
Untuk melakukan konfigurasi, kami melakukan beberapa settings terutama pada DHCP server. Berikut adalah settings yang kami gunakan. 

##### Konfigurasi Jipangu
Pada jipangu pertama sekali kami melakukan konfigurasi sebagai berikut
```bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update -y
apt-get install nano -y
apt-get install isc-dhcp-server -y
```
Dapat dilihat pertama sekali kami menambahkan nameserver pada Jipangu agar jipangu dapat mengakses internet. Setelah itu, kami melukan update dan melakukan installasi isc-dhcp-server. Setelah melakukan installasi, pada `/etc/default/isc-dhcp server` kami memasukkan interfaces eth0 menjadi sebagai berikut
``` bash
echo "
INTERFACES=\"eth0\"
" > /etc/default/isc-dhcp-server
```

Untuk melakukan Setting pada swith 1 kami memasukkan konfigurasi berikut ini pada `/etc/dhcp/dhcp.conf`
```
subnet 192.217.1.0 netmask 255.255.255.0 {
   range 192.217.1.20 192.217.1.99;
   range 192.217.1.150 192.217.1.169; 
   option routers 192.217.1.1;
   option broadcast-address 192.217.1.255;
   option domain-name-servers 192.217.2.2;
   default-lease-time 360;
   max-lease-time 7200;
}
```
dapat dilihat pada kode diatas, untuk subnet 192.217.1.0 kami mengatur range sesuai dengan ketentuan yang ada pada soal. Untuk switch 1 waktu lease adalah 6 menit atau 360 detik dan juga `max-lease-time` nya adalah 7200. `domain-name-servers` kami gunakan adalah EniesLobby (192.217.2.2).  

Untuk melakukan setting pada swith 2 kami memasukkan konfigurasi berikut ini pada `/etc/dhcp/dhcp.conf`
```
subnet 192.217.3.0 netmask 255.255.255.0 {
   range 192.217.3.30 192.217.3.50; 
   option routers 192.217.3.1;
   option broadcast-address 192.217.3.255;
   option domain-name-servers 192.217.2.2;
   default-lease-time 720;
   max-lease-time 7200;
}
```
dapat dilihat dari kode tersebut, kami sudah mengatur range IP sesuai dengan ketentuan dari soal. Untuk switch 2 waktu lease adalah 12 menit atau 720 detik dan juga `max-lease-time` nya adalah 7200. `domain-name-servers` kami gunakan adalah EniesLobby (192.217.2.2).

Untuk menjalankan relay, tidak lupa juga kami menambahkan konfigurasi berikut ini pada `/etc/dhcp/dhcp.conf`
```
subnet 192.217.2.0 netmask 255.255.255.0{}
```

##### Konfigurasi Client
Untuk menerapkan DHCP pada setiap client, kita harus merubah settingan pada `/etc/network/interfaces` menjadi
```bash
auto eth0
iface eth0 inet dhcp
```

##### Konfigurasi EniesLobby
Karena pada soal ada permintaan bahwa dari DNS server setiap client harus bisa mengakses internet, maka pada EniesLobby pertama sekali kami menjalan kode berikut ini 
```bash
echo "nameserver 192.168.122.1" >/etc/resolv.conf
apt-get update -y
apt-get install nano -y
apt-get install bind9 -y
apt-get install lynx -y
```
Hal yang kami lakukan adalah memasukkan nameserver yang sama dengan yang ada pada Foosha. setelah bisa mengakses internet maka kami melakukan update dan instalasi Bind9. Setelah itu, kami membuat kode DNS Forwarder pada `/etc/bind/named.conf.options` agar setiap client bisa mengakses internet melalui Foosha sebagai berikut : 
```bash
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
```
### Uji Coba

##### Pada Loguetown
![image](https://user-images.githubusercontent.com/50267676/141642894-e1de332c-fdf0-450b-bc86-d2095db296d9.png)

##### Pada Alabasta
![image](https://user-images.githubusercontent.com/50267676/141642800-fbd7334a-dacf-4d93-ad9f-ceb5b9cb934e.png)

##### Pada TottoLand
![image](https://user-images.githubusercontent.com/50267676/141642861-a1c9dcc8-5bc8-4679-a940-ae97507b74ab.png)

Dapat dilihat bahwa, setiap client sudah mendapatkan IP secara DHCP dengan range yang sudah ditentukan sebelumnya. Dan setiap Client juga sudah mendapatkan nameserver dari EniesLobby.

### Soal Nomor 7
Luffy dan Zoro berencana menjadikan Skypie sebagai server untuk jual beli kapal yang dimilikinya dengan alamat IP yang tetap dengan IP [prefix IP].3.69

### Jawaban Nomor 7
##### Konfigurasi Skypie
Untuk menjadikan Skypie mendapatkan alamat IP tetap, pertama sekali kita harus mendapatkan hwaddress dari skype dan mengatur `/etc/network/interfaces` menjadi sebagai berikut
```
auto eth0
iface eth0 inet dhcp
hwaddress ether de:d3:23:e1:5d:c1 
```
alamat `de:d3:23:e1:5d:c1 ` merupakan hwaddress pada skypie.

##### Konfigurasi Jipangu
Pada jipangu kami menambahkan kode berikut ini agar skypie mendapatkan alamat tetap pada `/etc/dhcp/dhcp.conf`
```
host Skypie {
    hardware ethernet de:d3:23:e1:5d:c1;
    fixed-address 192.217.3.69;
}
```
dapat dilihat bahwa, kami memasukkan `fixed-address 192.217.3.69` untuk Skypie. Sehingga secara keseluruhan isi code dari `/etc/dhcp/dhcp.conf` adalah sebagai berikut ini
```bash
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
```

### Uji Coba
![image](https://user-images.githubusercontent.com/50267676/141643101-9a14a99d-a4d8-4a62-a237-428b4164c556.png)

dapat dilihat bahwa, Skypie sudah menggunakan alamat tetap yatu 192.217.3.69 dan sudah mendapatkan namserver secara otomatis.

### Soal Nomor 8 9 10
- Pada Loguetown, proxy harus bisa diakses dengan nama jualbelikapal.yyy.com dengan port yang digunakan adalah 5000 (8). 
- Agar transaksi jual beli lebih aman dan pengguna website ada dua orang, proxy dipasang autentikasi user proxy dengan enkripsi MD5 dengan dua username, yaitu luffybelikapalyyy dengan password luffy_yyy dan zorobelikapalyyy dengan password zoro_yyy (9). 
- Transaksi jual beli tidak dilakukan setiap hari, oleh karena itu akses internet dibatasi hanya dapat diakses setiap hari Senin-Kamis pukul 07.00-11.00 dan setiap hari Selasa-Jum’at pukul 17.00-03.00 keesokan harinya (sampai Sabtu pukul 03.00) (10).

### Jawaban Soal Nomor 8 9 10
##### Konfigurasi Water7
Untuk menjadikan Water7 sebagai proxy server, pertama sekali melakukan installasi sebagai berikut
```bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update -y
apt-get install nano -y
apt-get install squid -y
mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
```
Setelah melakukan instalasi squid, kami melakukan backup setting bawaan dari squid tersebut. selanjutnya agar bisa diakses melalui port 5000, pada `/etc/squid/squid.conf` kami menambahkan kode berikut ini.
```
http_port 5000
visible_hostname Water7
```
Selanjutnya, agar transaksi lebih aman, kami menambahkan setingan authentikasi dengan menambahkan crediensial pengguna menggunakan htpasswd sebagai berikut
```bash
apt-get install apache2-utils -y
htpasswd -b -c /etc/squid/passwd luffybelikapalt12 luffy_t12 
htpasswd -b /etc/squid/passwd zorobelikapalt12 zoro_t12
```
Setelah menambahkan kode tersebut, kita perlu untuk menambahkan settingan berikut ini pada `/etc/squid/squid.conf`
```
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 5
auth_param basic realm Proxy
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive on
acl USERS proxy_auth REQUIRED
http_access allow USERS
```
Berikutnya, untuk membatasi waktu akses kami menambahkan settingan pada `/etc/squid/acl.conf` sebagai berikut
```
acl AVAILABLE_WORKING time MTWH 07:00-11:00
acl AVAILABLE_WORKING time TWHF 17:00-23:59
acl AVAILABLE_WORKING time A    00:00-03:00
```
untuk setingan dari Hari dan jam nya disesuaikan dengan soal yang ada. Setelah membuat settingan tersebut, pada `/etc/squid/acl.conf` ditambahkan kode berikut ini
```
include /etc/squid/acl.conf
http_access allow AVAILABLE_WORKING
http_access deny al
```

##### Konfigurasi EnniesLobby
Karena pada soal diminta proxy harus bisa diakses dengan nama jualbelikapal.yyy.com, maka kita perlu membuat sebuah domain pada EniesLobby. Pertama sekali, kita perlu membuat settingan pada `/etc/bind/named.conf.local` sebagai berikut ini
```bash
echo "
zone \"jualbelikapal.t12.com\" {
        type master;
        file \"/etc/bind/jarkom/jualbelikapal.t12.com\";
};
"> /etc/bind/named.conf.local
mkdir -p  /etc/bind/jarkom
```
setelah itu kami memembuat sebuah directory jarkom untuk menyimpan setinggan file dari domain jualbelikapal.t12.com. Lalu kami membuat file jualbelikapal.t12.com pada folder jarkom tersebut dan kami isi dengan konfigurasi berikut ini 
```
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
```
dapat dilihat bahwa domani jualbelikapal.t12.com akan diarahkan menuju IP 192.217.2.3 (Water7).

### Uji Coba
Pada loguetown, pertama sekali jalankan proxy dengan perintah
```bash
export http_proxy="http://jualbelikapal.t12.com:5000"
```

![image](https://user-images.githubusercontent.com/50267676/141644113-e71598a0-9c83-4a47-92cc-43f8604d73ae.png)
^^ Meminta Authentikasi User terlebih dahulu

![image](https://user-images.githubusercontent.com/50267676/141643787-f51af8e5-f6d8-40d5-a9b4-9bc57becd71b.png)
^^ Ketika waktu yang sudah diatur sesuai dengan waktu saat menggunakan proxy.


### Soal Nomor 11
Agar transaksi bisa lebih fokus berjalan, maka dilakukan redirect website agar mudah mengingat website transaksi jual beli kapal. Setiap mengakses google.com, akan diredirect menuju super.franky.yyy.com dengan website yang sama pada soal shift modul 2. Web server super.franky.yyy.com berada pada node Skypie

### jawaban Soal Nomor 11
##### konfigurasi Skypie (Webserver)
kami menggunakan konfigurasi yang sama dengan modul sebelumnya. berikut adalah konfigurasi yang kami gunakan 
``` bash
apt-get install apache2 -y
apt-get install php -y
apt-get install libapache2-mod-php7.0 -y
apt-get install wget -y
apt-get install unzip -y
apt-get install apache2-utils -y
echo "
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/super.franky.t12.com
        ServerName super.franky.t12.com
        ServerAlias www.super.franky.t12.com
        <Directory /var/www/super.franky.t12.com/public>
                Options +Indexes
        </Directory>
        #<Directory /var/www/super.franky.t12.com/public/*>
        #        Options -Indexes
        #</Directory>
        Alias \"/js\" \"/var/www/super.franky.t12.com/public/js\"
        ErrorDocument 404 /error/404.html
        <Files \"/var/www/super.franky.t12.com/error/404.html\">
                <If \"-z %{ENV:REDIRECT_STATUS}\">
                        RedirectMatch 404 ^/error/404.html$
                </If>
        </Files>
         <Directory /var/www/super.franky.t12.com>
                Options +FollowSymLinks -Multiviews
                AllowOverride All
        </Directory>
        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
" > /etc/apache2/sites-available/super.franky.t12.com.conf

mkdir /var/www/super.franky.t12.com
wget https://raw.githubusercontent.com/FeinardSlim/Praktikum-Modul-2-Jarkom/main/super.franky.zip
unzip super.franky.zip
mv super.franky/* /var/www/super.franky.t12.com
rm -r super.franky
a2ensite super.franky.t12.com
service apache2 restart
```

##### Konfigurasi Water7
untuk melakukan redirect kami menambahkan kode berikut ini pada `/etc/squid/squid.conf` sebagai berikut 
```
dns_nameservers 192.217.2.2
acl badsites dstdomain google.com
deny_info http://super.franky.t12.com/ badsites
deny_info ERR_ACCESS_DENIED all
http_reply_access deny badsites
```
penambahan `dns_nameservers 192.217.2.2` ditujukan agar super.franky.t12.com ditemukan.

### Ujicoba
![image](https://user-images.githubusercontent.com/50267676/141644537-760eee42-aa90-4e2c-a43f-5155d1250121.png)
![image](https://user-images.githubusercontent.com/50267676/141644518-0dc90378-72bd-4efe-88df-afc6623fa828.png)
^^ sudah diarahkan ke super.franky.t12.com

### Soal nomor 12 dan 13
Saatnya berlayar! Luffy dan Zoro akhirnya memutuskan untuk berlayar untuk mencari harta karun di super.franky.yyy.com. Tugas pencarian dibagi menjadi dua misi, Luffy bertugas untuk mendapatkan gambar (.png, .jpg), sedangkan Zoro mendapatkan sisanya. Karena Luffy orangnya sangat teliti untuk mencari harta karun, ketika ia berhasil mendapatkan gambar, ia mendapatkan gambar dan melihatnya dengan kecepatan 10 kbps (12). Sedangkan, Zoro yang sangat bersemangat untuk mencari harta karun, sehingga kecepatan kapal Zoro tidak dibatasi ketika sudah mendapatkan harta yang diinginkannya (13).

### Jawaban soal nomor 12 dan 13
Untuk melakukan limitasi dari speeddownload, maka kami menambahkan setingan berikut ini pada `/etc/squid/squid.conf`
```
acl multimedia url_regex -i \.png$ \.jpg$
acl bar proxy_auth luffybelikapalt07
delay_pools 1
delay_class 1 1
delay_parameters 1 1250/6400
delay_access 1 allow multimedia bar
delay_access 1 deny ALL
http_access deny ALL
```
tujuannya adalah membatasi speed download luffy ketika melakukan pemeriksaan terkait PNG dan JPG

### Ujicoba
pada loguetown, atur proxy dengan credential berikut ini
```bash
export http_proxy="http://zorobelikapalt07:zoro_t07@jualbelikapal.t07.com:5000"
```