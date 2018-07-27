# Class profiles::base
class profiles::base {
  exec {
    'apt-update':
        command => '/usr/bin/apt-get update --yes --fix-missing'
  }
  ensure_packages(lookup('enhancer_packages'),{
      ensure => present,
      provider => apt,
  })
  user {
    'Prime User' :
        ensure => present,
        name   => lookup('username'),
  }
}
