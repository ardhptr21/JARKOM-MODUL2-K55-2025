# ==== TIRION ====
cat <<EOF >> /etc/bind/k55/k55.com
www       IN       CNAME      sirion.k55.com.
static    IN       CNAME      lindon.k55.com.
app       IN       CNAME      elrond.k55.com.

EOF

service bind9 restart