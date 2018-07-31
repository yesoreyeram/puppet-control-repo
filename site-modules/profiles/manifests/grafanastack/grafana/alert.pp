# Class: profiles::grafanastack::grafana::alert
#
#
class profiles::grafanastack::grafana::alert {
  include ::profiles::grafanastack::base
  include ::profiles::grafanastack::grafana::base
  $grafanaversion = '5.1.3'
  $cfg = {
    server   => {
      http_port     => 3001,
    }
  }
  notify { 'Installing Grafana alert':
    require => Class['::profiles::grafanastack::grafana::base']
  }
  file {
    ['/opt/grafana/alert/','/opt/grafana/storage/alert/','/opt/grafana/storage/alert/conf'] :
      ensure  => directory,
      group   => lookup('username'),
      owner   => lookup('username'),
      require => Class['::profiles::grafanastack::grafana::base']
  }
  mysql::db { 'grafana-alert':
    user     => 'root',
    password => lookup('mysql_password'),
    require  => Class['::profiles::grafanastack::grafana::base']
  }
  exec {
    'Extract Grafana alert':
      path     => '/usr/bin:/usr/sbin:/bin',
      provider => shell,
      command  => "tar -xzvf /opt/puppet/packages/grafana-${grafanaversion}.tar.gz -C /opt/grafana/alert --strip-components=1",
      unless   => "cat /opt/grafana/alert/VERSION | grep ${grafanaversion}",
      require  => File['/opt/grafana/alert/'],
  }
  file {
    '/opt/grafana/storage/alert/conf/grafana.ini':
        ensure  => file,
        content => template('grafana/config.ini.erb'),
        owner   => lookup('username'),
        group   => lookup('username')
  }
  supervisord::program {
    'grafana-alert':
      command             => '/opt/grafana/alert/bin/grafana-server --homepath=/opt/grafana/alert/ --config=/opt/grafana/storage/alert/conf/grafana.ini &',
  }
}
