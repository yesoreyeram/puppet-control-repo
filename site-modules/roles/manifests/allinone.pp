# Class roles::allinone 
class roles::allinone {
  include ::profiles::base
  include ::profiles::grafanastack::base
  include ::profiles::grafana::prime
  include ::profiles::grafana::alert
  include ::profiles::graphite::combined
}
