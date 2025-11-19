#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y apache2 php php-cli php-mysql

systemctl enable apache2
systemctl restart apache2


rm -rf /var/www/html/*

# Send PHP files in ./shared
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;


