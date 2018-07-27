# Class profiles::grafanastack::python
class profiles::grafanastack::pip {
  include ::profiles::grafanastack::python
  python::pip { 'pip-pip' :
    ensure  => '9.0.3',
    pkgname => 'pip',
    require => Class['Python']
  }
}
