# Class: profiles::gstack::base
#
#
class profiles::gstack::base {
  #region OS Specific packages
  $redhat_specific_packages = ['epel-release', 'libffi-devel', 'openssl-devel']
  $debian_specific_packages = ['apt-utils','apt-transport-https','apache2-utils','build-essential', 'libssl-dev', 'libffi-dev','jq']
  case $::osfamily {
    'RedHat' : { ensure_packages( $redhat_specific_packages , { ensure => present, } ) }
    'Debian' : { ensure_packages( $debian_specific_packages , { ensure => present, } ) }
    default   : { notice('Not supported') }
  }
  #endregion
  #region Create User
  user { 'grafana_user' :
        ensure => present,
        name   => lookup('username'),
  }
  #endregion
  #region Package directories
  file { ['/opt/puppet/packages/','/opt/data/','/opt/data/log/'] :
      ensure => directory,
      owner  => lookup('username'),
      group  => lookup('username'),
  }
  #endregion
}
