# Class profiles::grafanastack::base
class profiles::grafanastack::base {
  notice('Applying Grafana stack base profile')
  user {
    'Grafana User' :
        ensure => present,
        name   => lookup('username'),
  }
  include ::profiles::grafanastack::python
  include ::profiles::grafanastack::pip
  include ::profiles::grafanastack::supervisor
  include ::profiles::grafanastack::nginx
  include ::profiles::grafanastack::nodejs
}