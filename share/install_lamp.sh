#!/usr/bin/env bash
echo "Installing LAMP stack..."
apt-get update >/dev/null 2>&1
debconf-set-selections <<< 'mysql-server mysql-server/root_password password 123'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 123'
apt-get -y install lamp-server^ >/dev/null 2>&1
echo "Creating symlink to /var/www..."
rm -rf /var/www
ln -fs /vagrant /var/www
a2enmod rewrite >/dev/null 2>&1
sed -i '/AllowOverride None/c AllowOverride All' /etc/apache2/sites-available/default >/dev/null 2>&1
service apache2 restart >/dev/null 2>&1
# Fix 'Servername error'
#echo "ServerName localhost" | sudo tee /etc/apache2/conf.d/fqdn >/dev/null 2>&1
# Restart apache
service apache2 reload >/dev/null 2>&1
