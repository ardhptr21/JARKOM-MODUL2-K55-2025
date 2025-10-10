# ==== TIRION ====
cat <<EOF >> /etc/bind/k55/jarkom-k55.com
havens      IN       CNAME    www.jarkom-k55.com.
EOF

service bind9 restart