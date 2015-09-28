# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define "techtonic" do |env|
    #env.vm.box = "ubuntu/trusty64"
    #env.vm.hostname = "home"
    env.vm.network "private_network", ip: "10.10.10.10"
    env.vm.synced_folder "scripts/", "/home/vagrant/scripts"
    env.vm.synced_folder "share/", "/home/vagrant/share"
    env.vm.post_up_message = $message
  end
  config.vm.provider "virtualbox" do |vb|
    #vb.name = "techtonic-env-" + Time.now.to_i.to_s
    vb.gui = true
    vb.cpus = 8
    vb.memory = 8192
    vb.customize ["modifyvm", :id, "--monitorcount", "2"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--nictype1", "virtio" ]
    vb.customize ["modifyvm", :id, "--nictype2", "virtio" ]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/vagrant", "1"]
  end
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
end

$message = <<MSG
All Done!
MSG