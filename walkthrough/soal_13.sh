# ==== SIRION ====
cat <<EOF > /etc/nginx/sites-available/default
server {
    server_name 10.91.3.2;
    return 301 http://www.k55.com\$request_uri;
}

server {
    listen 80;
    server_name www.k55.com sirion.k55.com 10.91.3.2;

    proxy_set_header Host \$host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for
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

    location ^~ /admin/ {
        auth_basic "Sirion Restricted Area";
        auth_basic_user_file /etc/nginx/.htpasswd;
        alias /var/www/admin/;
        index index.html;
    }
}
EOF