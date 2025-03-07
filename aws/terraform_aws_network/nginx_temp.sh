#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras enable nginx
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

cat <<EOF | sudo tee /etc/nginx/nginx.conf
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server internal-private-lb-202306052.eu-central-1.elb.amazonaws.com:80;
    }

    server {
        listen 80;
        server_name _;

        location / {
            proxy_pass http://backend;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }
}
EOF

sudo systemctl restart nginx

