#!/bin/bash
mkdir -p /opt/puppet/logs/
cp /opt/puppet/logs/puppetrun.log /opt/puppet/logs/puppetrun.previous.log 2>/dev/null
echo "" > /opt/puppet/logs/puppetrun.log

PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin
if [ -x "/usr/bin/facter" ]; then FACTER="/usr/bin/facter"; fi
if [ -x "/opt/puppetlabs/bin/facter" ]; then FACTER="/opt/puppetlabs/bin/facter"; fi
if [ -x "/usr/bin/puppet" ]; then PUPPET="/usr/bin/puppet"; fi
if [ -x "/opt/puppetlabs/bin/puppet" ]; then PUPPET="/opt/puppetlabs/bin/puppet"; fi
PUPPETFILE="/opt/puppet/Puppetfile"
MODULEDIR="/opt/puppet/modules/"
MODULEPATH="/opt/puppet/modules/:/opt/puppet/site-modules/"
HEIRA_CONFIG="/opt/puppet/hiera.yaml"
ENTRYPOINT="/opt/puppet/manifests/site.pp"
GEM="/opt/puppetlabs/puppet/bin/gem"
R10K="/opt/puppetlabs/puppet/bin/r10k"
BUNDLE="/opt/puppetlabs/puppet/bin/bundle"
GEMFILE="/opt/puppet/Gemfile"

echo "==========================================================" # >> /opt/puppet/logs/puppetrun.log
echo "$(date) INFO : Installing required Puppet modules" # >> /opt/puppet/logs/puppetrun.log
echo "==========================================================" # >> /opt/puppet/logs/puppetrun.log
echo "$(date) INFO : Puppet modules list - Before install/update" # >> /opt/puppet/logs/puppetrun.log
$PUPPET module list --tree --modulepath=$MODULEDIR # >> /opt/puppet/logs/puppetrun.log
echo "$(date) INFO : Installing modules from /opt/puppet/Puppetfile" # >> /opt/puppet/logs/puppetrun.log
$R10K puppetfile install --puppetfile $PUPPETFILE --moduledir $MODULEDIR # >> /opt/puppet/logs/puppetrun.log
echo "$(date) INFO : Puppet modules list - After install/update" # >> /opt/puppet/logs/puppetrun.log
$PUPPET module list --tree --modulepath=$MODULEDIR # >> /opt/puppet/logs/puppetrun.log

echo "==========================================================" # >> /opt/puppet/logs/puppetrun.log
echo "$(date) INFO : Installing required gems" # >> /opt/puppet/logs/puppetrun.log
echo "==========================================================" # >> /opt/puppet/logs/puppetrun.log
$GEM install bundler
$GEM install toml
#$BUNDLE install --gemfile=$GEMFILE

echo "==========================================================" # >> /opt/puppet/logs/puppetrun.log
echo "$(date) INFO : Applying puppet" # >> /opt/puppet/logs/puppetrun.log
echo "==========================================================" # >> /opt/puppet/logs/puppetrun.log
$PUPPET apply --modulepath=$MODULEPATH --hiera_config=$HEIRA_CONFIG $ENTRYPOINT -v # >> /opt/puppet/logs/puppetrun.log

echo "==========================================================" # >> /opt/puppet/logs/puppetrun.log
echo "$(date) INFO : Puppet apply completed" # >> /opt/puppet/logs/puppetrun.log
echo "==========================================================" # >> /opt/puppet/logs/puppetrun.log
exit 0;
