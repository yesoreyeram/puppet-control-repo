# Class profiles::grafanastack::base::python
class profiles::grafanastack::base::pip {
  include ::profiles::grafanastack::base::python
  python::pip { 'pip-pip' :
    ensure  => '18.0',
    pkgname => 'pip',
    require => Class['Python'],
  }
  python::pip { 'pip-setuptools' :
    ensure  => '40.0.0',
    pkgname => 'setuptools',
    require => Class['Python'],
  }
}
