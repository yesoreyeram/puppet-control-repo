# Class profiles::gstack::base::nodejs
class profiles::gstack::base::nodejs {
  class { 'nodejs' :
    target_dir => '/bin',
    version    => 'v8.9.4',
  }
  exec { 'npm-http-server' :
    path    => '/usr/bin:/usr/sbin:/bin',
    command => 'npm install -g --prefix / http-server',
    unless  => ['test -f /bin/http-server'],
    require => Class['nodejs'],
  }
  exec { 'npm-pm2' :
    path    => '/usr/bin:/usr/sbin:/bin',
    command => 'npm install -g --prefix / pm2',
    unless  => ['test -f /bin/pm2'],
    require => Class['nodejs'],
  }
}
