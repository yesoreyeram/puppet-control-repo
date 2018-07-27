# Class profiles::grafanastack::base
class profiles::grafanastack::base {
  notice('Applying Grafana stack base profile')
  include ::profiles::grafanastack::nginx
  include ::profiles::grafanastack::nodejs
}
