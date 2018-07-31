# Class profiles::grafanastack::base
class profiles::grafanastack::base {
  if $osfamily == 'RedHat' {
    ensure_packages(['epel-release', 'libffi-devel', 'openssl-devel'],{
        ensure => present,
    })
  }
  if $osfamily == 'Debian' {
    ensure_packages(['apt-utils','apt-transport-https','apache2-utils','build-essential', 'libssl-dev', 'libffi-dev'],{
        ensure => present,
    })
  }
  notice('Applying Grafana stack base profile')
  user { 'Grafana User' :
        ensure => present,
        name   => lookup('username'),
  }
  file { ['/opt/puppet/packages/'] :
      ensure  => directory,
      group   => lookup('username'),
      owner   => lookup('username'),
      require => User['Grafana User'],
  }
  include ::profiles::grafanastack::base::python
  include ::profiles::grafanastack::base::pip
  include ::profiles::grafanastack::base::supervisor
  include ::profiles::grafanastack::base::nginx
  /*
  include ::profiles::grafanastack::base::nodejs
  */
}
