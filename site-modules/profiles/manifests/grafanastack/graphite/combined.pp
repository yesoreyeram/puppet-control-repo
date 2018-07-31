# Class: profiles::grafanastack::graphite::combined
#
#
class profiles::grafanastack::graphite::combined {
  include ::profiles::grafanastack::graphite::base
  include ::profiles::grafanastack::graphite::storage
  notice('Graphite combined profile')
}
