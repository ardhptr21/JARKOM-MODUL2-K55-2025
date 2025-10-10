# ==== TIRION ====
cat <<EOF >> /etc/bind/k55/jarkom-k55.com
; TXT CNAME record
melkor       IN       TXT      "Morgoth (Melkor)"
morgoth      IN       CNAME    melkor.jarkom-k55.com.
EOF

service bind9 restart

dig melkor.jarkom-k55.com TXT
dig morgoth.jarkom-k55.com TXT