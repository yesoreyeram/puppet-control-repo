# Class: profiles::gstack::base::memcached
#
#
class profiles::gstack::base::memcached {
  class { 'memcached' :
    max_memory => '12%'
  }
}
