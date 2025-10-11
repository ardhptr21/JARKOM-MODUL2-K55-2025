# ==== TIRION ====
cat <<EOF >> /etc/bind/k55/k55.com
; TXT CNAME record
melkor       IN       TXT      "Morgoth (Melkor)"
morgoth      IN       CNAME    melkor.k55.com.
EOF

service bind9 restart

dig melkor.k55.com TXT
dig morgoth.k55.com TXT