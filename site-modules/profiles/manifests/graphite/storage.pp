# Class: profiles::graphite::storage
#
#
class profiles::graphite::storage {
  include ::profiles::graphite::base
  include ::profiles::grafanastack::memcached
}
