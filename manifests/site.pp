notice('Welcome to Puppet Control Repo')
notice("${lookup('welcome')}")
notice($fqdn)

node default {
  warning('No matching roles found')
}
