# Class: profiles::gstack::base
#
#
class profiles::gstack::base (
  String        $username                 = lookup('profiles::gstack::general_settings::username'),
  Array[String] $redhat_specific_packages = lookup('profiles::gstack::general_setting::enhancer_packages_redhat'),
  Array[String] $debian_specific_packages = lookup('profiles::gstack::general_setting::enhancer_packages_debian'),
) {
  #region OS Specific packages
  case $::osfamily {
    'RedHat' : { ensure_packages( $redhat_specific_packages , { ensure => present, } ) }
    'Debian' : { ensure_packages( $debian_specific_packages , { ensure => present, } ) }
    default  : { notice('Not supported') }
  }
  #endregion
  #region Create User
  user { 'grafana_user' :
        ensure => present,
        name   => $username,
  }
  #endregion
  #region Package directories
  file { ['/opt/puppet/packages/','/opt/data/','/opt/data/log/'] :
      ensure => directory,
      owner  => $username,
      group  => $username,
  }
  #endregion
}
