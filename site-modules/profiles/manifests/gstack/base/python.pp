# Class: profiles::gstack::base::python
#
#
class profiles::gstack::base::python {
  class { 'python' :
    version    => 'system',
    pip        => 'present',
    dev        => 'present',
    virtualenv => 'present',
    gunicorn   => 'absent',
  }
}
