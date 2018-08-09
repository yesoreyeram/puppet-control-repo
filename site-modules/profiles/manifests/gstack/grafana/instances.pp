# Class: profiles::gstack::grafana::instances
#
#
class profiles::gstack::grafana::instances {
  ::profiles::gstack::grafana::instance { 'grafana-prime':  instance_name => 'prime'  }
  ::profiles::gstack::grafana::instance { 'grafana-alert':  instance_name => 'alert'  }
}
