# Class profiles::grafanastack::nodejs
class profiles::grafanastack::nodejs {
  class { 'nodejs':
    version => 'v8.9.4',
  }
  package { 'pm2':
    provider => 'npm',
    require  => Class['nodejs']
  }
  package { 'http-server':
    provider => 'npm',
    require  => Class['nodejs']
  }
}
