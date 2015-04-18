# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
  end
  config.vm.define 'kali-client' do |env|
    env.vm.box = "cmad/kali"
    env.vm.hostname = 'kali-client'
    if Vagrant.has_plugin?("vagrant-hostmanager")
      env.hostmanager.aliases = %w(kali.client.io)
    end
    env.vm.network "private_network", ip: "10.10.10.10"
    env.vm.provision "shell", inline: ""
    env.vm.post_up_message = $message
  end
  config.vm.define 'dvwa-server' do |env|
    env.vm.box = "hashicorp/precise32"
    env.vm.hostname = 'dmva-server'
    if Vagrant.has_plugin?("vagrant-hostmanager")
      env.hostmanager.aliases = %w(dvwa.server.io)
    end
    env.vm.network "private_network", ip: "10.10.10.11"
    env.vm.provision "shell", path: "assets/bin/provision.sh"
  end
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
  end
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
end

$message = <<MSG
░█░█░█▀█░█░░░▀█▀
░█▀▄░█▀█░█░░░░█░
░▀░▀░▀░▀░▀▀▀░▀▀▀
VM Name ---> kali-client
IP --------> 10.10.10.10
Hostname --> kali.client.io

░█▀▄░█░█░█░█░█▀█
░█░█░▀▄▀░█▄█░█▀█
░▀▀░░░▀░░▀░▀░▀░▀
VM Name ---> dvwa-server
IP --------> 10.10.10.11
Hostname --> dvwa.server.io
Username: admin
Password: password

MSG