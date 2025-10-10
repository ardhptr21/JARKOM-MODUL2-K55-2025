# ==== EONWE ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
  address 10.91.1.1
  netmask 255.255.255.0

auto eth2
iface eth2 inet static
  address 10.91.2.1
  netmask 255.255.255.0

auto eth3
iface eth3 inet static
  address 10.91.3.1
  netmask 255.255.255.0
EOF

# ==== EARENDIL ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
  address 10.91.1.2
  netmask 255.255.255.0
  gateway 10.91.1.1
EOF

# ==== ELWING ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
  address 10.91.1.3
  netmask 255.255.255.0
  gateway 10.91.1.1
EOF

# ==== CIRDAN ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
  address 10.91.2.2
  netmask 255.255.255.0
  gateway 10.91.2.1
EOF

# ==== ELROND ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
  address 10.91.2.3
  netmask 255.255.255.0
  gateway 10.91.2.1
EOF


# ==== MAGROL ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
  address 10.91.2.4
  netmask 255.255.255.0
  gateway 10.91.2.1
EOF


# ==== SIRION ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
  address 10.91.3.2
  netmask 255.255.255.0
  gateway 10.91.3.1
EOF

# ==== TIRION ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
  address 10.91.3.3
  netmask 255.255.255.0
  gateway 10.91.3.1
EOF

# ==== VALMAR ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
  address 10.91.3.4
  netmask 255.255.255.0
  gateway 10.91.3.1
EOF

# ==== LINDON ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
  address 10.91.3.5
  netmask 255.255.255.0
  gateway 10.91.3.1
EOF

# ==== VINGILOT ====
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
  address 10.91.3.6
  netmask 255.255.255.0
  gateway 10.91.3.1
EOF
