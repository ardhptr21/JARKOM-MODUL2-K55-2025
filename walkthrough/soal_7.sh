# ==== TIRION ====
cat <<EOF >> /etc/bind/k55/jarkom-k55.com
; Subdomain CNAME record
www       IN       CNAME      sirion.jarkom-k55.com.
static    IN       CNAME      lindon.jarkom-k55.com.
app       IN       CNAME      elrond.jarkom-k55.com.
EOF

service bind9 restart