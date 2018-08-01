# Class: profiles::gstack::base::pip
#
#
class profiles::gstack::base::pip {
  include ::profiles::gstack::base::python
  python::pip { 'pip-pip' :
    ensure  => '18.0',
    pkgname => 'pip',
    require => Class['Python'],
  }
}
