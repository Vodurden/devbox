# -*- mode: ruby; -*-

Vagrant.configure("2") do |config|
  config.vm.box = "devbox"

  config.vm.provider :virtualbox do |vb|
    vb.gui = true

    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    vb.customize ["setextradata", :id, "GUI/MaxGuestResolution", "any" ]
    vb.customize ["setextradata", :id, "CustomVideoMode1", "1980x1200x32"]

    vb.customize ["modifyvm", :id, "--cpus", "3"]
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--vram", "256"]
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.ssh.insert_key = false
  # config.ssh.password = "vagrant"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "172.17.8.11"

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "E:\\Projects", "/home/jake/code"

  # Upload files and merge them into the box root
  config.vm.provision :file, source: "files", destination: "/tmp/"
  config.vm.provision :shell, path: "scripts/apply_files.sh"
end
