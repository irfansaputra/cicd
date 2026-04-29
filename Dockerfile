FROM php:8.2-fpm-alpine

# Install nginx
RUN apk add --no-cache nginx

# Copy file web
COPY index.html /var/www/html/
COPY kirim.php /var/www/html/

# Config nginx
RUN mkdir -p /run/nginx

COPY <<EOF /etc/nginx/http.d/default.conf
server {
    listen 80;
    root /var/www/html;
    index index.html index.php;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
}
EOF

CMD php-fpm & nginx -g "daemon off;"
