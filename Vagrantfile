# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "nixos/nixos-16.09-x86_64"

  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |vb|
    vb.gui = true

    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
    vb.customize ['setextradata', :id, 'GUI/MaxGuestResolution', 'any']
    vb.customize ['setextradata', :id, 'CustomVideoMode1', '1980x1200x32']

    vb.customize ['modifyvm', :id, '--cpus', '3']
    vb.customize ['modifyvm', :id, '--memory', '4096']
    vb.customize ['modifyvm', :id, '--vram', '256']
    vb.customize ['modifyvm', :id, '--hwvirtex', 'on']
    vb.customize ['modifyvm', :id, '--ioapic', 'on']
  end

  config.vm.synced_folder 'E:\\Projects', '/code', mount_options: ['fmode=777,dmode=777']
end
