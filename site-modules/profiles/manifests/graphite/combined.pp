# Class: profiles::graphite::combined
#
#
class profiles::graphite::combined {
  include ::profiles::graphite::base
  include ::profiles::graphite::storage
  notice('Graphite combined profile')
}
