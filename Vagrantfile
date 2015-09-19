# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define 'web-server' do |server|
    server.vm.provider 'virtualbox' do |vb|
      vb.name = 'techtonic-web-server-' + Time.now.to_i.to_s
      vb.gui = false
    end
    server.vm.box = 'hashicorp/precise32'
    #server.vm.box_url = 'https://atlas.hashicorp.com/hashicorp/boxes/precise32'
    server.vm.network 'private_network', ip: '10.10.10.10'
    server.vm.synced_folder 'vault/', '/home/vagrant/vault'
    server.vm.synced_folder 'bin/', '/home/vagrant/bin'
    server.vm.provision 'shell', inline: $install_web_server
    server.vm.post_up_message = $message
  end
  config.vm.define 'db-server' do |db|
    config.vm.provider 'virtualbox' do |vb|
      vb.name = 'techtonic-db-server-' + Time.now.to_i.to_s
      vb.gui = false
    end
    db.vm.box = 'hashicorp/precise32'
    db.vm.network 'private_network', ip: '10.10.10.11'
    db.vm.synced_folder 'vault/', '/home/vagrant/vault'
    db.vm.synced_folder 'bin/', '/home/vagrant/bin'
    db.vm.network 'forwarded_port', guest: 5984, host: 5984, auto_correct: true
    db.vm.provision 'shell', path: 'bin/install_couchdb.sh'
  end
  config.vm.provider 'virtualbox' do |vb|
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/vagrant", "1"]
  end
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
end

$message = <<MSG
░█░█░█▀▀░█▀▄
░█▄█░█▀▀░█▀▄
░▀░▀░▀▀▀░▀▀░
VM Name ---> web-server
IP --------> 10.10.10.10
MySQL Username: root
MySQL Password: 123

░█▀▄░█▀▄
░█░█░█▀▄
░▀▀░░▀▀░
VM Name ---> db-server
IP --------> 10.10.10.11
MSG

$install_web_server = <<WEB
  printf "Installing various items..."
  sudo apt-get update >/dev/null 2>&1
  sudo apt-get install -y make >/dev/null 2>&1
  sudo apt-get install -y curl >/dev/null 2>&1
  sudo apt-get install -y build-essential >/dev/null 2>&1

  printf "Installing LAMP stack..."
  sudo apt-get update >/dev/null 2>&1
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password 123'
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 123'
  sudo apt-get -y install lamp-server^ >/dev/null 2>&1

  printf "Creating symlink to /var/www..."
  sudo rm -rf /var/www
  sudo ln -fs /vagrant /var/www
  sudo a2enmod rewrite >/dev/null 2>&1
  sudo sed -i '/AllowOverride None/c AllowOverride All' /etc/apache2/sites-available/default >/dev/null 2>&1
  sudo service apache2 restart >/dev/null 2>&1
  # Fix 'Servername error'
  #printf "ServerName localhost" | sudo tee /etc/apache2/conf.d/fqdn >/dev/null 2>&1
  # Restart apache
  sudo service apache2 reload >/dev/null 2>&1
WEB