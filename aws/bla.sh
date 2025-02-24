#!/bin/bash

cat > /etc/nginx/sites-enabled/default <<EOF
server {

    listen 8080;

    location / {

        resolver 8.8.8.8;

        proxy_pass http://$http_host$uri$is_args$args;

    }

}
server {

    listen 80;

    location / {

        resolver 8.8.8.8;

        proxy_pass http://$http_host$uri$is_args$args;

    }

}
server {

    listen 443;

    location / {

        resolver 8.8.8.8;

        proxy_pass http://$http_host$uri$is_args$args;

    }

}
EOF
