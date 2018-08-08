node 'allinone.dev.vm', 'allinoneu16.dev.vm', 'allinonec7.dev.vm','asinf-grafana-puppet-poc-centos' {
  include ::roles::gstack::allinone
}

node default {
  warning('No matching roles found')
}
