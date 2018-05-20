read -p "Write the host name, eg. google:" HOST;
read -p "Write the 1st level domain name without starting dot (.), eg. com.au:" DOMAIN;

mkdir -p /var/www/$HOST.$DOMAIN/web
mkdir -p /var/www/$HOST.$DOMAIN/logs
mkdir -p /var/www/$HOST.$DOMAIN/ssl

mkdir /etc/nginx/sites-available/
touch /etc/nginx/sites-available/$HOST.$DOMAIN

echo "server {
    listen 80;

    server_name www.$HOST.$DOMAIN $HOST.$DOMAIN;

    root /var/www/$HOST.$DOMAIN/web;
    index index.php index.html index.htm;

    access_log /var/www/$HOST.$DOMAIN/logs/access.log;
    error_log /var/www/$HOST.$DOMAIN/logs/error.log warn;

    location / {
        try_files $uri $uri/ /index.php?q=$uri&$args;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_intercept_errors on;
        include fastcgi_params;

        fastcgi_cache_use_stale error timeout invalid_header http_500;
        fastcgi_cache_key $host$request_uri;
        fastcgi_cache_valid 200 1m;
    }

    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    location ~ /\.git/* {
        deny all;
    }

    location ~ /\.svn/* {
        deny all;
    }

    location /nginx_status {
        stub_status on;
        access_log off;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
    }

    location ~ ^/(status|ping)$ {
        include /etc/nginx/fastcgi_params;
        fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $fastcgi_script_name;
        allow 127.0.0.1;
        deny all;
    }

    charset UTF-8;
    gzip on;
    gzip_http_version 1.1;
    gzip_vary on;
    gzip_comp_level 6;
    gzip_proxied any;
    gzip_types text/plain text/xml text/css application/x-javascript;
    
}" >> /etc/nginx/sites-available/$HOST.$DOMAIN

ln -s /etc/nginx/sites-available/$HOST.$DOMAIN /etc/nginx/conf.d/$HOST.$DOMAIN.conf

service nginx restart;