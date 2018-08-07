Vagrant.configure("2") do |config|

  # Host manager settings
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true  
  
  # General Settings
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/opt/puppet/"
  config.vm.synced_folder "./runtime/allinone/", "/etc/puppetlabs/facter/facts.d/"
  
  # All in one Node - Centos 7
  config.vm.define "allinone" do |allinone|
    allinone.vm.box = "puppet-centos-7"
    allinone.vm.hostname = "allinone.dev.vm"
    allinone.hostmanager.aliases = %w(allinone.dev.vm dev-allinone)
    allinone.vm.network "private_network", ip: "192.168.50.5"
    #allinone.vm.provision "shell", path: "scripts/bootstrap-centos.sh"
  end

end