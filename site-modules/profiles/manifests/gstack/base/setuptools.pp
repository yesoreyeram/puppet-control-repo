# Class: profiles::gstack::base::pip
#
#
class profiles::gstack::base::setuptools {
  include ::profiles::gstack::base::python
  include ::profiles::gstack::base::pip
  python::pip { 'pip-setuptools' :
    ensure  => '40.0.0',
    pkgname => 'setuptools',
    require => [Class['::profiles::gstack::base::python'],Class['::profiles::gstack::base::pip']],
  }
}
