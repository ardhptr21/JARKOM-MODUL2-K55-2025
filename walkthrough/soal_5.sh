# ==== TIRION ====
cat <<EOF >> /etc/bind/k55/k55.com
earendil       IN       A      10.91.1.2
elwing         IN       A      10.91.1.3
cirdan         IN       A      10.91.2.2
elrond         IN       A      10.91.2.3
maglor         IN       A      10.91.2.4
sirion         IN       A      10.91.3.2
lindon         IN       A      10.91.3.5
vingilot       IN       A      10.91.3.6

EOF

service bind9 restart