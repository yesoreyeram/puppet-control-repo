Vagrant.configure("2") do |config|

  # Host manager settings
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  
  config.vm.box_check_update = false
  # Synced Folders
  config.vm.synced_folder ".", "/opt/puppet/"
  config.vm.synced_folder "./runtime/allinone/", "/etc/puppetlabs/facter/facts.d/"
  
  # All in one Node - Ubuntu 16.04
  config.vm.define "allinoneu16" do |allinoneu16|
    allinoneu16.vm.box = "ubuntu/xenial64"
    allinoneu16.vm.hostname = "allinoneu16.dev.vm"
    allinoneu16.hostmanager.aliases = %w(allinoneu16.dev.vm dev-allinoneu16)
    allinoneu16.vm.network "private_network", ip: "192.168.50.4"
    allinoneu16.vm.provision "shell", path: "scripts/bootstrap-ubuntu.sh"
  end

  # All in one Node - Centos 7
  config.vm.define "allinonec7" do |allinonec7|
    allinonec7.vm.box = "centos/7"
    allinonec7.vm.hostname = "allinonec7.dev.vm"
    allinonec7.hostmanager.aliases = %w(allinonec7.dev.vm dev-allinonec7)
    allinonec7.vm.network "private_network", ip: "192.168.50.5"
    allinonec7.vm.provision "shell", path: "scripts/bootstrap-centos.sh"
  end

end