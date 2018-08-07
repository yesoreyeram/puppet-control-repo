#!/bin/bash
yum -y update;
yum -y install curl nano git;
yum -y groupinstall "Development Tools";
rpm -ivh https://yum.puppetlabs.com/puppet5/puppet-release-el-7.noarch.rpm
sudo yum check-update
yum -y install puppet puppet-agent facter -y
/opt/puppetlabs/puppet/bin/gem install r10k
mkdir -p /etc/puppetlabs/facter/facts.d/
exit 0;