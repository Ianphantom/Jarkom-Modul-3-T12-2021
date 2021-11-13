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