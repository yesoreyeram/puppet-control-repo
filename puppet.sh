#!/bin/bash
mkdir -p /opt/puppet/logs/
cp /opt/puppet/logs/puppetrun.log /opt/puppet/logs/puppetrun.previous.log 2>/dev/null
echo "" > /opt/puppet/logs/puppetrun.log

echo "==========================================================" # >> /opt/puppet/logs/puppetrun.log
echo "$(date) INFO : Installing required Puppet modules" # >> /opt/puppet/logs/puppetrun.log
echo "==========================================================" # >> /opt/puppet/logs/puppetrun.log
echo "$(date) INFO : Puppet modules list - Before install/update" # >> /opt/puppet/logs/puppetrun.log
/opt/puppetlabs/bin/puppet module list --tree --modulepath=/opt/puppet/modules/ # >> /opt/puppet/logs/puppetrun.log
echo "$(date) INFO : Installing modules from /opt/puppet/Puppetfile" # >> /opt/puppet/logs/puppetrun.log
/opt/puppetlabs/puppet/bin/r10k puppetfile install --puppetfile /opt/puppet/Puppetfile --moduledir /opt/puppet/modules/ # >> /opt/puppet/logs/puppetrun.log
echo "$(date) INFO : Puppet modules list - After install/update" # >> /opt/puppet/logs/puppetrun.log
/opt/puppetlabs/bin/puppet module list --tree --modulepath=/opt/puppet/modules/ # >> /opt/puppet/logs/puppetrun.log

echo "==========================================================" # >> /opt/puppet/logs/puppetrun.log
echo "$(date) INFO : Applying puppet" # >> /opt/puppet/logs/puppetrun.log
echo "==========================================================" # >> /opt/puppet/logs/puppetrun.log
/opt/puppetlabs/bin/puppet apply --modulepath=/opt/puppet/modules/:/opt/puppet/site-modules/ --hiera_config=/opt/puppet/hiera.yaml /opt/puppet/manifests/site.pp -v # >> /opt/puppet/logs/puppetrun.log

echo "==========================================================" # >> /opt/puppet/logs/puppetrun.log
echo "$(date) INFO : Puppet apply completed" # >> /opt/puppet/logs/puppetrun.log
echo "==========================================================" # >> /opt/puppet/logs/puppetrun.log
exit 0;
