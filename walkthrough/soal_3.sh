# ==== SEMUA HOST ====
cat <<EOF > /root/.bashrc
echo "nameserver 192.168.122.1" > /etc/resolv.conf
EOF