# Class: profiles::gstack::grafana::alert
#
#
class profiles::gstack::grafana::alert {
  include ::profiles::gstack::base
  include ::profiles::gstack::grafana::base
  $grafanaversion =  lookup('grafana_version')
  $cfg = {
    server   => {
      http_port     => 3004,
    }
  }
  file {
    ['/opt/grafana/alert/','/opt/grafana/storage/alert/','/opt/grafana/storage/alert/conf'] :
      ensure  => directory,
      group   => lookup('username'),
      owner   => lookup('username'),
      require => Class['::profiles::gstack::grafana::base']
  }
  mysql::db { 'grafana-alert':
    user     => 'root',
    password => lookup('mysql_password'),
    require  => Class['::profiles::gstack::grafana::base']
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
        content => template('profiles/gstack/grafana/config.ini.erb'),
        owner   => lookup('username'),
        group   => lookup('username'),
        require => File['/opt/grafana/storage/alert/conf/']
  }
  supervisord::program {
    'grafana-alert':
      command   => '/opt/grafana/alert/bin/grafana-server --homepath=/opt/grafana/alert/ --config=/opt/grafana/storage/alert/conf/grafana.ini &',
      subscribe => File['/opt/grafana/storage/alert/conf/grafana.ini'],
      require   => [Exec['Extract Grafana alert'], File['/opt/grafana/storage/alert/conf/grafana.ini'] ]
  }
  exec {
    'restart-supervisord-alert' :
      path        => '/usr/bin:/usr/sbin:/bin',
      provider    => shell,
      command     => 'supervisorctl restart grafana-alert',
      subscribe   => [File['/opt/grafana/storage/alert/conf/grafana.ini']],
      require     => Supervisord::Program['grafana-alert'],
      refreshonly => true,
  }
}
