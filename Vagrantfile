# -*- mode: ruby; -*-

Vagrant.configure('2') do |config|
  # Bento boxes have 40gb of space, while the regular debian one is only 10gb.
  # I don't want to have to manually expand the disk size, it's a real hassle!
  config.vm.box = 'bento/debian-8.6'

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

  # `vagrant-cachier` plugin configuration
  config.cache.scope = :box
  config.cache.enable :generic, {
    "maven" => { cache_dir: "/home/jake/.m2/repository" },
    "ivy2" => { cache_dir: "/home/jake/.ivy2/cache" },
    "rubygems" => { cache_dir: "/home/jake/.rbenv/versions" },
    "rubygems-sources" => { cache_dir: "/home/jake/.rbenv/sources" }
  }

  # We want to chown any caches in the home folder to ensure they're still owned by the correct user
  chown_paths = [".m2", ".ivy2", ".rbenv"].map { |f| "/home/jake/#{f}" }.join(" ")
  config.vm.provision :shell, :inline => "chown -R jake:jake #{chown_paths}"

  config.ssh.insert_key = false

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: '172.17.8.11'

  config.vm.synced_folder '.', '/vagrant'
  config.vm.synced_folder 'E:\\Projects', '/code', mount_options: ['fmode=777,dmode=777']

  config.vm.provision :shell, privileged: true, path: 'vagrant/scripts/bootstrap_ansible.sh'
  config.vm.provision :ansible_local do |ansible|
    ansible.install = true
    ansible.install_mode = :pip
    ansible.version = '2.1.2'

    ansible.galaxy_role_file = 'ansible/requirements.yml'
    ansible.galaxy_roles_path = 'ansible/galaxy_roles'
    ansible.playbook = 'ansible/virtualbox-debian.yml'
    ansible.sudo = true
    ansible.verbose = 'v'
  end
end
