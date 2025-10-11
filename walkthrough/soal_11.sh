# ==== SIRION ====
apt update
apt install nginx -y

cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80;
    server_name www.k55.com sirion.k55.com;

    proxy_set_header Host \$host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP \$remote_addr;

    location / {
        root /var/www/html;
        index index.html index.htm;
        try_files $uri $uri/ =404;
    }

    location /static/ {
        proxy_pass http://lindon.k55.com/;
    }

    location /app/ {
        proxy_pass http://vingilot.k55.com/;
    }
}
EOF

service nginx restart