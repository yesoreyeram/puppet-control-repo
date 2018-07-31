# Class: profiles::grafanastack::graphite::storage
#
#
class profiles::grafanastack::graphite::storage {
  include ::profiles::grafanastack::base::memcached
  include ::profiles::grafanastack::graphite::base
}
