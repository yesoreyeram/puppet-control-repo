#!/bin/bash
echo "==========================================================";
echo "Installing required Puppet modules";
echo "==========================================================";
echo "Puppet modules list - Before install/update";
/opt/puppetlabs/bin/puppet module list --tree --modulepath=/opt/puppet/modules/
echo "Installing modules from /opt/puppet/Puppetfile";
/opt/puppetlabs/puppet/bin/r10k puppetfile install --puppetfile /opt/puppet/Puppetfile --moduledir /opt/puppet/modules/;
echo "Puppet modules list - After install/update";
/opt/puppetlabs/bin/puppet module list --tree --modulepath=/opt/puppet/modules/
echo "==========================================================";
echo "Applying puppet";
echo "==========================================================";
/opt/puppetlabs/bin/puppet apply --modulepath=/opt/puppet/modules/:/opt/puppet/site-modules/ --hiera_config=/opt/puppet/hiera.yaml /opt/puppet/manifests/site.pp -v;
echo "Puppet apply completed";
echo "==========================================================";
exit 0;
