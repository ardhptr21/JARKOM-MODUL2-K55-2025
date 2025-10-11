# ==== TIRION ====
cat <<EOF >> /etc/bind/k55/k55.com
havens      IN       CNAME    www.k55.com.

EOF

service bind9 restart