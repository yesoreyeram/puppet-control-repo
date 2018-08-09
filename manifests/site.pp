node 'allinone.dev.vm', 'allinoneu16.dev.vm', 'allinonec7.dev.vm','asinf-grafana-puppet-poc-centos' {
  include ::roles::gstack::allinone
}

node default {
  include ::roles::gstack::allinone
  warning('No matching roles found. So allinone role assigned')
}
