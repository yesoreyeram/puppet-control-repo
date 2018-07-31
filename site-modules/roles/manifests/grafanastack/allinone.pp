# Class roles::allinone 
class roles::grafanastack::allinone {
  include ::profiles::base
  include ::profiles::grafanastack::base
  include ::profiles::grafanastack::grafana::prime
  include ::profiles::grafanastack::grafana::alert
  include ::profiles::grafanastack::graphite::combined
}
