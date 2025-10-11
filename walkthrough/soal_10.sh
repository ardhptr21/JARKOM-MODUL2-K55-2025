# ==== VINGILOT ====
apt update
apt install apache2 php php8.4-fpm libapache2-mod-fcgid -y

cat <<EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@vingilot.k55.com
    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/var/run/php/php8.4-fpm.sock|fcgi://localhost/"
    </FilesMatch>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF

cat <<EOF > /var/www/html/.htaccess
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^about$ about.php [L]
EOF

cat <<EOF > /var/www/html/index.php
<?php
echo "Hello Vingilot";
?>
EOF

cat <<EOF > /var/www/html/about.php
<?php
echo "About Vingilot";
?>
EOF

service php8.4-fpm restart
a2enmod proxy_fcgi setenvif rewrite
service apache2 restart