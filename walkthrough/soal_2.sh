# ==== EONWE ====
echo "==== Check DNS EONWE ===="
cat <<EOF > /root/.bashrc
apt update
apt install iptables -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.91.0.0/16
EOF


