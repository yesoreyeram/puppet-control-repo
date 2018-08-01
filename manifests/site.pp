notice('Welcome to Puppet Control Repo')
notice("${lookup('welcome')}")
notice($fqdn)

node 'allinoneu16.dev.vm', 'allinonec7.dev.vm' {
  include ::roles::gstack::allinone
}

node default {
  warning('No matching roles found')
}
