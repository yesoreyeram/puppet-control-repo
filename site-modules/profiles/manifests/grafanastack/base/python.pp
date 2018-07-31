# Class profiles::grafanastack::python
class profiles::grafanastack::base::python {
  class { 'python' :
    version    => 'system',
    pip        => 'present',
    dev        => 'present',
    virtualenv => 'present',
    gunicorn   => 'absent',
  }
}
