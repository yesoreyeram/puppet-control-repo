notice('Welcome to Puppet Control Repo')
notice("${lookup('welcome')}")
notice($fqdn)

node 'allinone.dev.vm', 'allinonec7.dev.vm' {
  include "::roles::grafanastack::allinone"
}

node default {
  warning('No matching roles found')
}
