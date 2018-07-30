#!/bin/bash
yum -y update;
yum -y install curl nano git;
rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm;
yum -y install puppet;
yum -y install facter;
/opt/puppetlabs/puppet/bin/gem install r10k
mkdir -p /etc/puppetlabs/facter/facts.d/
exit 0;