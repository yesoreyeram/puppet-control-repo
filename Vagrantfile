Vagrant.configure("2") do |config|

  # Host manager settings
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  
  # All in one Node
  config.vm.define "allinone" do |allinone|

    # Image Settings
    allinone.vm.box = "ubuntu/xenial64"
    allinone.vm.hostname = "allinone.dev.vm"
    allinone.vm.box_check_update = false
    allinone.hostmanager.aliases = %w(allinone.dev.vm dev-allinone)
    
    # Synced Folders
    allinone.vm.synced_folder ".", "/opt/puppet/"
    allinone.vm.synced_folder "./runtime/allinone/", "/etc/puppetlabs/facter/facts.d/"
    
    # Network Settings
    allinone.vm.network "private_network", ip: "192.168.50.4"
    
    # Provisioning
    allinone.vm.provision "shell", path: "scripts/bootstrap-ubuntu.sh"

  end

end