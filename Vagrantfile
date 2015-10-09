# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define "techtonic" do |env|
    env.vm.box = "test"
    #env.vm.hostname = "home"
    env.vm.post_up_message = $message
  end
  config.vm.provider "virtualbox" do |vb|
    #vb.name = "techtonic-env-" + Time.now.to_i.to_s
    vb.gui = true
    vb.cpus = 4
    vb.memory = 8192
    vb.customize ["modifyvm", :id, "--monitorcount", "2"]
  end
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
end

$message = <<MSG
All Done!
MSG