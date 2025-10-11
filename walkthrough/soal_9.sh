# ==== LINDON ====
apt update
apt install apache2 -y

mkdir -p /var/www/annals/ && chown www-data:www-data /var/www/annals/

cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@lindon.k55.com
    DocumentRoot /var/www/annals
    <Directory /var/www/annals>
        Options +Indexes
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF

service apache2 restart