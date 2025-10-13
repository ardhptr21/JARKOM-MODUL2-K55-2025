#!/bin/bash

# =================================================================
# Soal 17: Mengaktifkan Auto-Start untuk Semua Layanan Inti
# =================================================================
#
# Petunjuk:
# Buka terminal untuk setiap server yang disebutkan di bawah ini,
# lalu salin (copy) dan jalankan (paste) blok perintah
# yang sesuai untuk server tersebut.

# === Di TIRION (ns1) ===
echo "Menjalankan konfigurasi di Tirion..."
apt update
apt install bind9 -y
update-rc.d bind9 defaults
echo "Layanan bind9 di Tirion telah diaktifkan."

# === Di VALMAR (ns2) ===
echo "Menjalankan konfigurasi di Valmar..."
apt update
apt install bind9 -y
update-rc.d bind9 defaults
echo "Layanan bind9 di Valmar telah diaktifkan."

# === Di SIRION (Reverse Proxy) ===
echo "Menjalankan konfigurasi di Sirion..."
apt update
apt install nginx -y
update-rc.d nginx defaults
echo "Layanan nginx di Sirion telah diaktifkan."

# === Di LINDON (Web Statis) ===
echo "Menjalankan konfigurasi di Lindon..."
apt update
apt install apache2 -y
update-rc.d apache2 defaults
echo "Layanan apache2 di Lindon telah diaktifkan."

# === Di VINGILOT (Web Dinamis) ===
echo "Menjalankan konfigurasi di Vingilot..."
apt update
apt install apache2 php8.4-fpm -y
update-rc.d apache2 defaults
update-rc.d php8.4-fpm defaults
echo "Layanan apache2 dan php8.4-fpm di Vingilot telah diaktifkan."

echo ""
echo "--- Konfigurasi Soal 17 Selesai ---"