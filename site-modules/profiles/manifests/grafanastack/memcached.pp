# Class: profiles::grafanastack::memcached
#
#
class profiles::grafanastack::memcached {
  include ::profiles::grafanastack::base
  class { 'memcached':
    max_memory => '12%',
    require    => Class['::profiles::grafanastack::base']
  }
}
