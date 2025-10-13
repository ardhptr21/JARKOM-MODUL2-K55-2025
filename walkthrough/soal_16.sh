#nano /etc/bind/k55/k55.com

#Ubah baris lindon menjadi seperti ini untuk mengganti IP-nya ke 10.91.3.7 dan mengatur TTL 30 detik.
#lindon      30 IN       A      10.91.3.7

# Naikkan nomor serial di bagian atas file (baris Serial). Ubah angka terakhirnya saja sudah cukup.
# 2025100402 ; Serial


# $TTL    604800
# @       IN      SOA     ns1.k55.com. root.k55.com. (
#                         2025100401 ; Serial <-- ubah 401 jadi 402
#                         604800     ; Refresh
#                         86400      ; Retry
#                         2419200    ; Expire
#                         604800 )   ; Negative Cache TTL
# @        IN      NS     ns1.k55.com.
# @        IN      NS     ns2.k55.com.
# ns1      IN      A      10.91.3.3
# ns2      IN      A      10.91.3.4
# @        IN      A      10.91.3.2
# earendil       IN       A      10.91.1.2
# elwing         IN       A      10.91.1.3
# cirdan         IN       A      10.91.2.2
# elrond         IN       A      10.91.2.3
# maglor         IN       A      10.91.2.4
# sirion         IN       A      10.91.3.2
# lindon        30 IN       A      10.91.3.7  <--- ubah IP jadi 10.91.3.7 dan TTL jadi 30
# vingilot       IN       A      10.91.3.6
# www       IN       CNAME      sirion.k55.com.
# static    IN       CNAME      lindon.k55.com.
# app       IN       CNAME      vingilot.k55.com.

#!/bin/bash

# =================================================================
# BAGIAN 1: Jalankan skrip ini di TIRION (DNS Master)
# =================================================================
# Skrip ini akan:
# 1. Mengubah IP address lindon.k55.com menjadi 10.91.3.7
# 2. Menetapkan TTL 30 detik pada record tersebut
# 3. Menaikkan nomor serial SOA agar perubahan terdeteksi oleh slave
# 4. Merestart layanan BIND9

echo "Memperbarui record DNS di Tirion..."

# Menimpa file zone dengan konfigurasi baru
cat <<'EOF' > /etc/bind/k55/k55.com
$TTL    604800
@       IN      SOA     ns1.k55.com. root.k55.com. (
                        2025100402 ; Serial (Sudah dinaikkan)
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL

;-- Definisi Name Server
@        IN      NS     ns1.k55.com.
@        IN      NS     ns2.k55.com.
ns1      IN      A      10.91.3.3
ns2      IN      A      10.91.3.4
@        IN      A      10.91.3.2

;-- A Record untuk setiap host
earendil       IN       A      10.91.1.2
elwing         IN       A      10.91.1.3
cirdan         IN       A      10.91.2.2
elrond         IN       A      10.91.2.3
maglor         IN       A      10.91.2.4
sirion         IN       A      10.91.3.2
lindon      30 IN       A      10.91.3.7   ; <-- PERUBAHAN DI SINI
vingilot       IN       A      10.91.3.6

;-- CNAME Record untuk alias
www       IN       CNAME      sirion.k55.com.
static    IN       CNAME      lindon.k55.com.
app       IN       CNAME      vingilot.k55.com.
EOF

# Merestart BIND9 untuk menerapkan perubahan
service bind9 restart

echo "Konfigurasi di Tirion telah diperbarui. Lanjutkan verifikasi di Earendil."


# =================================================================
# BAGIAN 2: Jalankan skrip ini di EARENDIL (Klien)
# =================================================================
# Skrip ini akan melakukan verifikasi tiga momen:
# 1. Mengecek IP yang ada di cache (seharusnya IP lama)
# 2. Menunggu 40 detik agar cache kedaluwarsa
# 3. Mengecek IP lagi (seharusnya sudah IP baru)

echo "Memulai verifikasi di Earendil..."
echo ""
echo "--- Momen 1: Mengecek IP saat ini (kemungkinan masih dari cache lama) ---"
dig static.k55.com

echo ""
echo "Menunggu 40 detik agar cache TTL (30 detik) kedaluwarsa..."
sleep 40

echo ""
echo "--- Momen 3: Mengecek IP baru setelah cache hangus ---"
dig static.k55.com