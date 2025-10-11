# ==== TIRION ====
cat <<EOF >> /etc/bind/named.conf.local
zone "3.91.10.in-addr.arpa" {
    type master;
    file "/etc/bind/k55/3.91.10.in-addr.arpa";
    allow-transfer { 10.91.3.4; };
};

EOF

cat <<EOF > /etc/bind/k55/3.91.10.in-addr.arpa
\$TTL    604800          ; Waktu cache default (detik)
@       IN      SOA     ns1.k55.com. root.k55.com. (
                        2025100401 ; Serial (format YYYYMMDDXX)
                        604800     ; Refresh (1 minggu)
                        86400      ; Retry (1 hari)
                        2419200    ; Expire (4 minggu)
                        604800 )   ; Negative Cache TTL

@        IN      NS     ns1.k55.com.
@        IN      NS     ns2.k55.com.

2       IN       PTR    sirion.k55.com.
5       IN       PTR    lindon.k55.com.
6       IN       PTR    vingilot.k55.com.

EOF

service bind9 restart

# ==== VALMAR ====
cat <<EOF >> /etc/bind/named.conf.local
zone "3.91.10.in-addr.arpa" {
  type slave;
  masters { 10.91.3.3; };
  file "/var/lib/bind/k55/3.91.10.in-addr.arpa";
};

EOF

service bind9 restart

# ==== ANY NODE ====
host -t ptr 10.91.3.2
host -t ptr 10.91.3.5
host -t ptr 10.91.3.6