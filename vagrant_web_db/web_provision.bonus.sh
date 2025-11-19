#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive

# Update
apt-get update -y

# Apache + PHP + extensions + client MariaDB + phpMyAdmin
apt-get install -y apache2 php php-cli php-mysql mariadb-client phpmyadmin

# Activate & Start Apache
systemctl enable apache2
systemctl restart apache2

# Apache configuration for phpMyAdmin
cat << 'EOF' > /etc/apache2/conf-available/phpmyadmin.conf
Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php
    AllowOverride All
    Require all granted
</Directory>
EOF

a2enconf phpmyadmin
systemctl reload apache2

# Connectivity test index.php to the DB server
cat << 'EOF' > /var/www/html/index.php
<?php
$host = "192.168.56.11";
$user = "tp_user";
$pass = "tp_password";
$db   = "tp_db";

$dsn = "mysql:host=$host;dbname=$db;charset=utf8";

try {
    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);
    echo "<h1>Connexion à la base réussie ✅</h1>";
    echo "<p>Base : $db sur $host</p>";
} catch (PDOException $e) {
    echo "<h1>Erreur de connexion ❌</h1>";
    echo "<pre>" . htmlspecialchars($e->getMessage()) . "</pre>";
}
EOF

# Permissions of the shared file web if /var/www/html isn't a shared file 
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;
