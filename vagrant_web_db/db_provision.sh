#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y mariadb-server

# Listen interfaces
CONF_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"
if grep -q "^bind-address" "$CONF_FILE"; then
  sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' "$CONF_FILE"
else
  echo "bind-address = 0.0.0.0" >> "$CONF_FILE"
fi

systemctl enable mariadb
systemctl restart mariadb

# Script execution
mysql < /vagrant/db_sql/db_init.sql
