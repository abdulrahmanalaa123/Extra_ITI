#!/bin/bash

sudo yum update -y

# Install Apache (httpd)
sudo yum install -y httpd

# Start and enable Apache to run on boot
systemctl start httpd
systemctl enable httpd

# Create a simple HTML page
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My EC2 Instance</title>
</head>
<body>
    <h1>Welcome to My EC2 Instance</h1>
    <p>Instance ID: <strong>Hello from public</strong></p>
</body>
</html>
EOF

# Set proper permissions
chmod 644 /var/www/html/index.html

# Restart Apache to apply changes
systemctl restart httpd

