#!/usr/bin/env bash
set -e

export DEBIAN_FRONTEND=noninteractive

# Mise à jour
apt-get update -y

# Apache + PHP minimal
apt-get install -y apache2 php php-cli

# Activer Apache au démarrage + restart
systemctl enable apache2
systemctl restart apache2

# Nettoyage du dossier web
if [ -d /var/www/html ]; then
  rm -rf /var/www/html/*
fi

# Page d'accueil
cat << 'EOF' > /var/www/html/index.php
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>TP Vagrant LAMP</title>
</head>
<body>
  <h1>Bienvenue sur mon serveur LAMP 🎉</h1>
  <p>Serveur : lamp-server (Debian 13)</p>
  <p>Version de PHP : <?php echo phpversion(); ?></p>
</body>
</html>
EOF

# Droits sur le site
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# Message MOTD
cat << 'EOF' > /etc/motd
Bienvenue sur lamp-server (Vagrant Debian 13 - LAMP)
TP Vagrant LAMP - AFPA
EOF
