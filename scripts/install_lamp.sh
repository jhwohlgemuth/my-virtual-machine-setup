#!/usr/bin/env bash
echo "Installing LAMP stack..."
sudo apt-get update >/dev/null 2>&1
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password 123'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 123'
sudo apt-get -y install lamp-server^ >/dev/null 2>&1
echo "Creating symlink to /var/www..."
sudo rm -rf /var/www
sudo ln -fs /vagrant /var/www
sudo a2enmod rewrite >/dev/null 2>&1
sudo sed -i '/AllowOverride None/c AllowOverride All' /etc/apache2/sites-available/default >/dev/null 2>&1
sudo service apache2 restart >/dev/null 2>&1
# Fix 'Servername error'
#echo "ServerName localhost" | sudo tee /etc/apache2/conf.d/fqdn >/dev/null 2>&1
# Restart apache
sudo service apache2 reload >/dev/null 2>&1
