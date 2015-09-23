# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define 'techtonic' do |env|
    env.vm.box = 'ubuntu/trusty64'
    env.vm.hostname = 'home'
    env.vm.network 'private_network', ip: '10.10.10.10'
    env.vm.synced_folder 'vault/', '/home/vagrant/vault'
    env.vm.synced_folder 'bin/', '/home/vagrant/bin'
    env.vm.provision 'shell', path: 'bin/install_essential.sh'
    env.vm.provision 'shell', path: 'bin/install_desktop.sh'
    env.vm.post_up_message = $message
  end
  config.vm.provider 'virtualbox' do |vb|
    vb.name = 'techtonic-vm-' + Time.now.to_i.to_s
    vb.gui = true
    vb.cpus = 8
    vb.memory = 8192
    vb.customize ['setextradata', :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate/vagrant', '1']
    vb.customize ['modifyvm', :id, '--vram', '256']
    vb.customize ['modifyvm', :id, '--ioapic', 'on']
    vb.customize ['modifyvm', :id, '--pae', 'on']
    vb.customize ['modifyvm', :id, '--hwvirtex', 'on']
    vb.customize ['modifyvm', :id, '--chipset', 'ich9']
    vb.customize ['modifyvm', :id, '--accelerate3d', 'on']
    vb.customize ['modifyvm', :id, '--accelerate2dvideo', 'on']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    vb.customize ['modifyvm', :id, '--nictype1', 'virtio' ]
    vb.customize ['modifyvm', :id, '--nictype2', 'virtio' ]
    vb.customize ['modifyvm', :id, '--monitorcount', '2']
  end
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
end

$message = <<MSG
All Done!
MSG