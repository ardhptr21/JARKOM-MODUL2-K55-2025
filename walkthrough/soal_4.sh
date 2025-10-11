# ==== TIRION & VALMAR ====
apt update
apt install bind9 -y
ln -s /etc/init.d/named /etc/init.d/bind9

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

# ==== TIRION ====
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

cat <<EOF > /etc/bind/named.conf.local
zone "k55.com" {
  type master;
  file "/etc/bind/k55/k55.com";
  allow-transfer { 10.91.3.4; };
  notify yes;
};

EOF

service bind9 restart

# ==== VALMAR ====
mkdir -p /var/lib/bind/k55 && chown bind:bind /var/lib/bind/k55 && cat <<EOF > /etc/bind/named.conf.local
zone "k55.com" {
  type slave;
  masters { 10.91.3.3; };
  file "/var/lib/bind/k55/k55.com";
};

EOF

service bind9 restart

# ==== SEMUA HOST ====
echo "nameserver 10.91.3.3" > /etc/resolv.conf
echo "nameserver 10.91.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf