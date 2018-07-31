# Class: profiles::grafanastack::grafana::prime
#
#
class profiles::grafanastack::grafana::prime {
  include ::profiles::grafanastack::base
  include ::profiles::grafanastack::grafana::base
  $grafanaversion = '5.1.3'
  $cfg = {
    server   => {
      http_port     => 3002,
    }
  }
  notify { 'Installing Grafana prime':
    require => Class['::profiles::grafanastack::grafana::base']
  }
  file {
    ['/opt/grafana/prime/','/opt/grafana/storage/prime/','/opt/grafana/storage/prime/conf'] :
      ensure  => directory,
      group   => lookup('username'),
      owner   => lookup('username'),
      require => Class['::profiles::grafanastack::grafana::base']
  }
  mysql::db { 'grafana-prime':
    user     => 'root',
    password => lookup('mysql_password'),
    require  => Class['::profiles::grafanastack::grafana::base']
  }
  exec {
    'Extract Grafana prime':
      path     => '/usr/bin:/usr/sbin:/bin',
      provider => shell,
      command  => "tar -xzvf /opt/puppet/packages/grafana-${grafanaversion}.tar.gz -C /opt/grafana/prime --strip-components=1",
      unless   => "cat /opt/grafana/prime/VERSION | grep ${grafanaversion}",
      require  => File['/opt/grafana/prime/'],
  }
  file {
    '/opt/grafana/storage/prime/conf/grafana.ini':
        ensure  => file,
        content => template('grafana/config.ini.erb'),
        owner   => lookup('username'),
        group   => lookup('username')
  }
  supervisord::program {
    'grafana-prime':
      command => '/opt/grafana/prime/bin/grafana-server --homepath=/opt/grafana/prime/ --config=/opt/grafana/storage/prime/conf/grafana.ini &',
  }
}
