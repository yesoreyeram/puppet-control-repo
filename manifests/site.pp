notice('Welcome to Puppet Control Repo')
notice("${lookup('welcome')}")
notice($fqdn)

node 'allinone.dev.vm' {
  include ::roles::allinone
}

node default {
  warning('No matching roles found')
}
