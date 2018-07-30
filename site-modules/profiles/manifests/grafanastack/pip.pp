# Class profiles::grafanastack::python
class profiles::grafanastack::pip {
  include ::profiles::grafanastack::python
  python::pip { 'pip-pip' :
    ensure  => '18.0',
    pkgname => 'pip',
    require => Class['Python']
  }
  python::pip { 'pip-setuptools' :
    ensure  => '40.0',
    pkgname => 'setuptools',
    require => Class['Python']
  }  
}
