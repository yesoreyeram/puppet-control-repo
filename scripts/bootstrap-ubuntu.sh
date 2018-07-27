#!/bin/bash
apt-get update --yes;
apt-get install -y curl nano git;
curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
dpkg -i puppetlabs-release-pc1-xenial.deb
apt-get update --yes
apt-get -y install puppet-agent
/opt/puppetlabs/puppet/bin/gem install r10k
mkdir -p /etc/puppetlabs/facter/facts.d/
exit 0;