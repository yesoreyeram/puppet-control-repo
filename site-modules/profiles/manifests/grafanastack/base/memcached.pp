# Class: profiles::grafanastack::memcached
#
#
class profiles::grafanastack::base::memcached {
  include ::profiles::grafanastack::base
  class { 'memcached':
    max_memory => '12%',
    require    => Class['::profiles::grafanastack::base']
  }
}
