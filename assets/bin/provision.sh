#!/usr/bin/env bash

printf "Installing various items..."
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y curl >/dev/null 2>&1
echo "Installing JRE and JDK..."
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y default-jre >/dev/null 2>&1
sudo apt-get install -y default-jdk >/dev/null 2>&1
echo "Installing Python 2.7 and Python dev dependencies..."
sudo apt-get install -y build-essential >/dev/null 2>&1
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y python2.7 >/dev/null 2>&1
sudo apt-get install -y python-dev >/dev/null 2>&1
echo "Installing pip..."
sudo apt-get install -y python-pip >/dev/null 2>&1
echo "Installing Ruby..."
sudo apt-get install -y ruby-full >/dev/null 2>&1
echo "Installing node.js and npm..."
curl -sL https://deb.nodesource.com/setup | sudo bash - >/dev/null 2>&1
sudo apt-get install -y nodejs >/dev/null 2>&1
echo "Installing Git..."
sudo apt-get install -y git >/dev/null 2>&1
printf "Installing LAMP stack..."
sudo apt-get update >/dev/null 2>&1
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password p@ssw0rd'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password p@ssw0rd'
sudo apt-get -y install lamp-server^ >/dev/null 2>&1
printf "Creating symlink to /var/www..."
sudo rm -rf /var/www
sudo ln -fs /vagrant/DVWA /var/www
sudo a2enmod rewrite >/dev/null 2>&1
sudo sed -i '/AllowOverride None/c AllowOverride All' /etc/apache2/sites-available/default >/dev/null 2>&1
sudo service apache2 restart >/dev/null 2>&1
sudo service apache2 reload >/dev/null 2>&1