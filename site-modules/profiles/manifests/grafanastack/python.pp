# Class profiles::grafanastack::python
class profiles::grafanastack::python {
  class { 'python' :
    version    => 'system',
    pip        => 'present',
    dev        => 'absent',
    virtualenv => 'absent',
    gunicorn   => 'absent',
  }
  python::pip { 'pip-pip' :
    ensure  => '9.0.3',
    pkgname => 'pip',
    require => Class['python']
  }
}
