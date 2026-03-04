#!/bin/bash

sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
# Enable NGINX to start on boot
sudo systemctl enable nginx
sudo systemctl status nginx

echo "NGINX service is OK"

cd /var/www/html/
for i in page1.html page2.html page3.html; do
  touch "$i"
  chmod 644 "$i"
  chown www-data:www-data "$i"
done

# Check if Nginx is active using systemctl is-active --quiet nginx
if systemctl is-active --quiet nginx; then
    echo "Nginx is running. Force restarting now..."
    # Restart the service if it's running
    sudo systemctl restart nginx
else
    echo "Nginx is dead. Starting it now..."
    # Start the service if it's not running
    sudo systemctl start nginx
fi

journalctl -u nginx.service -n 5

echo "Homework2 Full Done"

