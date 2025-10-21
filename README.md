# PRAKTIKUM JARKOM MODUL 2 KELOMPOK 55 - 2025

## Angota Kelompok

| Nama                         | NRP        |
| ---------------------------- | ---------- |
| Ardhi Putra Pradana          | 5027241022 |
| M. Hikari Reiziq Rakhmadinta | 5027241079 |

## Laporan

1. Di tepi Beleriand yang porak-poranda, Eonwe merentangkan tiga jalur: Barat untuk Earendil dan Elwing, Timur untuk Círdan, Elrond, Maglor, serta pelabuhan DMZ bagi Sirion, Tirion, Valmar, Lindon, Vingilot. Tetapkan alamat dan default gateway tiap tokoh sesuai glosarium yang sudah diberikan.

---

![](assets/topology.png)

**Eonwe**

```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
  address 10.91.1.1
  netmask 255.255.255.0

auto eth2
iface eth2 inet static
  address 10.91.2.1
  netmask 255.255.255.0

auto eth3
iface eth3 inet static
  address 10.91.3.1
  netmask 255.255.255.0
```

**Earendil**

```
auto eth0
iface eth0 inet static
  address 10.91.1.2
  netmask 255.255.255.0
  gateway 10.91.1.1
```

**Elwing**

```
auto eth0
iface eth0 inet static
  address 10.91.1.3
  netmask 255.255.255.0
  gateway 10.91.1.1
```

**Cirdan**

```
auto eth0
iface eth0 inet static
  address 10.91.2.2
  netmask 255.255.255.0
  gateway 10.91.2.1
```

**Elrond**

```
auto eth0
iface eth0 inet static
  address 10.91.2.3
  netmask 255.255.255.0
  gateway 10.91.2.1
```

**Maglor**

```
auto eth0
iface eth0 inet static
  address 10.91.2.4
  netmask 255.255.255.0
  gateway 10.91.2.1
```

**Sirion**

```
auto eth0
iface eth0 inet static
  address 10.91.3.2
  netmask 255.255.255.0
  gateway 10.91.3.1
```

**Tirion**

```
auto eth0
iface eth0 inet static
address 10.91.3.3
netmask 255.255.255.0
gateway 10.91.3.1
```

**Valmar**

```
auto eth0
iface eth0 inet static
  address 10.91.3.4
  netmask 255.255.255.0
  gateway 10.91.3.1
```

**Lindon**

```
auto eth0
iface eth0 inet static
  address 10.91.3.5
  netmask 255.255.255.0
  gateway 10.91.3.1
```

**Vingilot**

```
auto eth0
iface eth0 inet static
  address 10.91.3.6
  netmask 255.255.255.0
  gateway 10.91.3.1
```

2. Angin dari luar mulai berhembus ketika Eonwe membuka jalan ke awan NAT. Pastikan jalur WAN di router aktif dan NAT meneruskan trafik keluar bagi seluruh alamat internal sehingga host di dalam dapat mencapai layanan di luar menggunakan IP address.

---
Isi konfigurasi pada router Eonwe /root/.bashrc
```sh
apt update
apt install iptables -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.91.0.0/16
```

3. Kabar dari Barat menyapa Timur. Pastikan kelima klien dapat saling berkomunikasi lintas jalur (routing internal via Eonwe berfungsi), lalu pastikan setiap host non-router menambahkan resolver 192.168.122.1 saat interfacenya aktif agar akses paket dari internet tersedia sejak awal.

---
Masukkan resolver 192.168.122.1 ke semua non-router
```sh
echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
Lalu untuk mengecek klien barat menyapa timur dengan ngeping ip 10.91.2.2 pada terminal router timur misal Earendil
```sh
ping 10.91.2.2
```
4. Para penjaga nama naik ke menara, di Tirion (ns1/master) bangun zona \<xxxx>.com sebagai authoritative dengan SOA yang menunjuk ke ns1.\<xxxx>.com dan catatan NS untuk ns1.\<xxxx>.com dan ns2.<xxxx>.com. Buat A record untuk ns1.\<xxxx>.com dan ns2.\<xxxx>.com yang mengarah ke alamat Tirion dan Valmar sesuai glosarium, serta A record apex \<xxxx>.com yang mengarah ke alamat Sirion (front door), aktifkan notify dan allow-transfer ke Valmar, set forwarders ke 192.168.122.1. Di Valmar (ns2/slave) tarik zona \<xxxx>.com dari Tirion dan pastikan menjawab authoritative. pada seluruh host non-router ubah urutan resolver menjadi ns1.\<xxxx>.com → ns2.\<xxxx>.com → 192.168.122.1. Verifikasi query ke apex dan hostname layanan dalam zona dijawab melalui ns1/ns2.

---

**Tirion**

```sh
apt update
apt install bind9 -y
ln -s /etc/init.d/named /etc/init.d/bind9
```

![](assets/tirion-bind-package.png)

```sh
cat <<EOF > /etc/bind/named.conf.options
options {
  directory "/var/cache/bind";

  forwarders {
    192.168.122.1;
  };

  allow-query { any; };
  auth-nxdomain no;
  listen-on { any; };
  listen-on-v6 { any; };
};

EOF
```

![](assets/tirion-named-options.png)

```sh
mkdir -p /etc/bind/k55 && cat <<EOF > /etc/bind/k55/k55.com
\$TTL    604800          ; Waktu cache default (detik)
@       IN      SOA     ns1.k55.com. root.k55.com. (
                        2025100401 ; Serial (format YYYYMMDDXX)
                        604800     ; Refresh (1 minggu)
                        86400      ; Retry (1 hari)
                        2419200    ; Expire (4 minggu)
                        604800 )   ; Negative Cache TTL

@        IN      NS     ns1.k55.com.
@        IN      NS     ns2.k55.com.

ns1     IN       A      10.91.3.3
ns2     IN       A      10.91.3.4

@       IN       A      10.91.3.2

EOF
```

![](assets/zone-conf-k55.png)

```sh
cat <<EOF > /etc/bind/named.conf.local
zone "k55.com" {
  type master;
  file "/etc/bind/k55/k55.com";
  allow-transfer { 10.91.3.4; };
  notify yes;
};

EOF
```

![](assets/config-zone-local-tirion.png)

```sh
service bind9 restart
```

![](assets/tirion-restart-bind.png)

```sh
echo "nameserver 10.91.3.3" > /etc/resolv.conf
echo "nameserver 10.91.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
```

```
dig @localhost k55.com
```

![](assets/dig-result-tirion.png)

**Valmar**

```sh
apt update
apt install bind9 -y
ln -s /etc/init.d/named /etc/init.d/bind9
```

```
cat <<EOF > /etc/bind/named.conf.options
options {
  directory "/var/cache/bind";

  forwarders {
    192.168.122.1;
  };

  allow-query { any; };
  auth-nxdomain no;
  listen-on { any; };
  listen-on-v6 { any; };
};

EOF
```

```sh
mkdir -p /var/lib/bind/k55 && chown bind:bind /var/lib/bind/k55 && cat <<EOF > /etc/bind/named.conf.local
zone "k55.com" {
  type slave;
  masters { 10.91.3.3; };
  file "/var/lib/bind/k55/k55.com";
};

EOF
```

![](assets/valmar-named-local.png)

```sh
service bind9 restart
```

![](assets/valmar-restart-bind.png)

![](assets/valmar-transfer-ok.png)

![](assets/dig-result-valmar.png)

**All node**

```sh
echo "nameserver 10.91.3.3" > /etc/resolv.conf
echo "nameserver 10.91.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
```

![](assets/other-client-dns-ok.png)

5. “Nama memberi arah,” kata Eonwe. Namai semua tokoh (hostname) sesuai glosarium, eonwe, earendil, elwing, cirdan, elrond, maglor, sirion, tirion, valmar, lindon, vingilot, dan verifikasi bahwa setiap host mengenali dan menggunakan hostname tersebut secara system-wide. Buat setiap domain untuk masing masing node sesuai dengan namanya (contoh: eru.<xxxx>.com) dan assign IP masing-masing juga. Lakukan pengecualian untuk node yang bertanggung jawab atas ns1 dan ns2

---

```sh
cat <<EOF >> /etc/bind/k55/k55.com
earendil       IN       A      10.91.1.2
elwing         IN       A      10.91.1.3
cirdan         IN       A      10.91.2.2
elrond         IN       A      10.91.2.3
maglor         IN       A      10.91.2.4
sirion         IN       A      10.91.3.2
lindon         IN       A      10.91.3.5
vingilot       IN       A      10.91.3.6

EOF
```

![](assets/update-subdomain-perhost.png)

```sh
service bind9 restart
```

![](assets/check-subdo-ok.png)

6. Lonceng Valmar berdentang mengikuti irama Tirion. Pastikan zone transfer berjalan, Pastikan Valmar (ns2) telah menerima salinan zona terbaru dari Tirion (ns1). Nilai serial SOA di keduanya harus sama

---

**Tirion**

```sh
dig @10.91.3.3 k55.com SOA +short
```

**Valmar**

```sh
dig @10.91.3.4 k55.com SOA +short
```

![](assets/check-serial-key-dns.png)

7. Peta kota dan pelabuhan dilukis. Sirion sebagai gerbang, Lindon sebagai web statis, Vingilot sebagai web dinamis. Tambahkan pada zona <xxxx>.com A record untuk sirion.<xxxx>.com (IP Sirion), lindon.<xxxx>.com (IP Lindon), dan vingilot.<xxxx>.com (IP Vingilot). Tetapkan CNAME :

   - www.<xxxx>.com → sirion.<xxxx>.com,
   - static.<xxxx>.com → lindon.<xxxx>.com, dan
   - app.<xxxx>.com → vingilot.<xxxx>.com.

   Verifikasi dari dua klien berbeda bahwa seluruh hostname tersebut ter-resolve ke tujuan yang benar dan konsisten.

---

```sh
cat <<EOF >> /etc/bind/k55/k55.com
www       IN       CNAME      sirion.k55.com.
static    IN       CNAME      lindon.k55.com.
app       IN       CNAME      elrond.k55.com.

EOF
```

![](assets/add-cname-dns.png)

```sh
service bind9 restart
```

![](assets/from-earendil-test-cname-ok.png)
![](assets/from-cirdan-test-cname-ok.png)

8. Setiap jejak harus bisa diikuti. Di Tirion (ns1) deklarasikan satu reverse zone untuk segmen DMZ tempat Sirion, Lindon, Vingilot berada. Di Valmar (ns2) tarik reverse zone tersebut sebagai slave, isi PTR untuk ketiga hostname itu agar pencarian balik IP address mengembalikan hostname yang benar, lalu pastikan query reverse untuk alamat Sirion, Lindon, Vingilot dijawab authoritative.

---

#### **Konfigurasi di Tirion (Master)**

Pertama, kami mendeklarasikan *reverse zone* `3.91.10.in-addr.arpa` di file `/etc/bind/named.conf.local`.

```sh
cat <<EOF >> /etc/bind/named.conf.local
zone "3.91.10.in-addr.arpa" {
    type master;
    file "/etc/bind/k55/3.91.10.in-addr.arpa";
    allow-transfer { 10.91.3.4; };
};
EOF
```

Selanjutnya, kami membuat file *zone*-nya dan mengisinya dengan *record* `PTR` untuk Sirion (`10.91.3.2`), Lindon (`10.91.3.5`), dan Vingilot (`10.91.3.6`).

```sh
cat <<EOF > /etc/bind/k55/3.91.10.in-addr.arpa
\$TTL    604800
@       IN      SOA     ns1.k55.com. root.k55.com. (
                        2025100401 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL

@        IN      NS     ns1.k55.com.
@        IN      NS     ns2.k55.com.

2       IN       PTR    sirion.k55.com.
5       IN       PTR    lindon.k55.com.
6       IN       PTR    vingilot.k55.com.
EOF
```

#### **Konfigurasi di Valmar (Slave)**

Di Valmar, kami mengkonfigurasinya sebagai *slave* untuk *reverse zone* yang sama, dengan menunjuk Tirion sebagai *master*.

```sh
cat <<EOF >> /etc/bind/named.conf.local
zone "3.91.10.in-addr.arpa" {
  type slave;
  masters { 10.91.3.3; };
  file "/var/lib/bind/k55/3.91.10.in-addr.arpa";
};
EOF
```

#### **Verifikasi**

Pengujian dilakukan dari klien **Earendil** menggunakan perintah:

```sh
host -t ptr 10.91.3.2
host -t ptr 10.91.3.5
host -t ptr 10.91.3.6
```
Hasil verifikasi menunjukkan bahwa setiap alamat IP berhasil dipetakan kembali ke *hostname* yang sesuai, menandakan konfigurasi *Reverse DNS* telah berhasil.

![](assets/Soal_8.png)



9. Lampion Lindon dinyalakan. Jalankan web statis pada hostname static.\<xxxx>.com dan buka folder arsip /annals/ dengan autoindex (directory listing) sehingga isinya dapat ditelusuri. Akses harus dilakukan melalui hostname, bukan IP.

---

Tentu, mari kita lanjutkan ke soal 9. Berikut adalah format laporan untuk `README.md` di GitHub, lengkap dengan penjelasan validasinya.

-----

### 9\. Lampion Lindon Dinyalakan (Web Server Statis)

Pada soal ini, kami bertugas untuk mengaktifkan **Lindon** sebagai *web server* statis. Sesuai permintaan, *server* ini harus menyajikan konten dari direktori `/annals/` dengan fitur *autoindex* (daftar file) aktif. Akses ke *server* ini dilakukan melalui *hostname* `static.k55.com`.

#### **Konfigurasi di Lindon**

Langkah pertama adalah menginstal **Apache2**, yang merupakan perangkat lunak *web server* yang akan kami gunakan.

```sh
apt update
apt install apache2 -y
```

Selanjutnya, kami membuat direktori `/var/www/annals/` yang akan menjadi *root* atau direktori utama untuk konten web.

```sh
mkdir -p /var/www/annals/
```

Kemudian, kami membuat file konfigurasi *Virtual Host* baru untuk Apache. Konfigurasi ini mengarahkan semua permintaan ke `DocumentRoot` `/var/www/annals` dan yang terpenting, mengaktifkan `Options +Indexes` untuk mengizinkan *directory listing*.

```sh
cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@lindon.k55.com
    DocumentRoot /var/www/annals
    <Directory /var/www/annals>
        Options +Indexes
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF
```

Terakhir, kami me-restart layanan Apache2 untuk menerapkan semua perubahan konfigurasi.

```sh
service apache2 restart
```

#### **Validasi**

Untuk membuktikan bahwa *web server* di Lindon berjalan dengan benar, kami melakukan validasi dari salah satu klien, yaitu **Earendil**.

**Cara Validasi:**
Kami menggunakan perintah `curl` untuk mengakses *hostname* `static.k55.com` dari terminal Earendil. `curl` adalah alat baris perintah yang digunakan untuk mentransfer data dengan URL, yang dalam kasus ini akan mengambil konten halaman web.

```sh
curl static.k55.com
```

**Hasil yang Diharapkan:**
Jika konfigurasi berhasil, perintah `curl` akan mengembalikan output berupa kode HTML. Output ini adalah halaman yang secara otomatis dibuat oleh Apache karena fitur `autoindex` aktif. Halaman ini akan berisi judul **"Index of /"**, yang menandakan bahwa *web server* berhasil menyajikan daftar isi dari direktori `/var/www/annals/`.

![](assets/soal_9.png)


10. Vingilot mengisahkan cerita dinamis. Jalankan web dinamis (PHP-FPM) pada hostname app.\<xxxx>.com dengan beranda dan halaman about, serta terapkan rewrite sehingga /about berfungsi tanpa akhiran .php. Akses harus dilakukan melalui hostname.

---

Pada tahap ini, kami mengkonfigurasi **Vingilot** untuk berfungsi sebagai *web server* dinamis yang dapat mengeksekusi skrip PHP. Implementasi ini menggunakan **PHP-FPM** (FastCGI Process Manager) untuk performa yang lebih baik dan menerapkan **URL Rewrite** agar URL lebih ramah pengguna.

-----

#### **Konfigurasi di Vingilot**

Langkah pertama adalah menginstal paket-paket yang diperlukan, yaitu Apache2, PHP, dan modul-modul terkait.

```sh
apt install apache2 php php8.4-fpm libapache2-mod-fcgid -y
```

Selanjutnya, kami mengkonfigurasi *Virtual Host* Apache untuk meneruskan permintaan file `.php` ke *service* PHP-FPM melalui *socket*.

```sh
cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@vingilot.k55.com
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        AllowOverride All
    </Directory>
    <FilesMatch \.php$>
        SetHandler "proxy:unix:/var/run/php/php8.4-fpm.sock|fcgi://localhost/"
    </FilesMatch>
</VirtualHost>
EOF
```

Untuk mengaktifkan URL *rewrite* (misalnya `/about` menjadi `about.php`), kami membuat file `.htaccess` di direktori web.

```sh
cat <<EOF > /var/www/html/.htaccess
RewriteEngine On
RewriteRule ^about$ about.php [L]
EOF
```

Kami juga membuat dua file PHP sederhana, `index.php` dan `about.php`, sebagai konten untuk validasi. Terakhir, kami mengaktifkan modul Apache yang diperlukan dan me-restart layanan PHP-FPM serta Apache2.

-----

#### **Validasi**

Untuk membuktikan bahwa *web server* dinamis di Vingilot berfungsi dengan benar, kami melakukan validasi dari klien **Earendil** menggunakan `curl`.

**Cara Validasi:**

1.  **Mengakses Halaman Utama:** Perintah ini untuk memverifikasi eksekusi PHP dasar.

    ```sh
    curl http://app.k55.com/
    ```

    **Hasil:** Server berhasil merespons dengan output dari `index.php`, yaitu `Hello Vingilot`.

    ![](assets/soal_10_1.png)


2.  **Mengakses Halaman dengan URL Rewrite:** Perintah ini untuk memverifikasi bahwa aturan di `.htaccess` berfungsi.

    ```sh
    curl http://app.k55.com/about
    ```

    **Hasil:** Server berhasil merespons dengan output dari `about.php`, yaitu `About Vingilot`.

    ![](assets/soal_10_2.png)


