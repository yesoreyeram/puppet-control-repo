# Class: profiles::gstack::grafana::prime
#
#
class profiles::gstack::grafana::prime {
  include ::profiles::gstack::base
  include ::profiles::gstack::grafana::base
  $grafanaversion =  lookup('grafana_version')
  $cfg = {
    server   => {
      http_port     => 3003,
    }
  }
  file {
    ['/opt/grafana/prime/','/opt/grafana/storage/prime/','/opt/grafana/storage/prime/conf'] :
      ensure  => directory,
      group   => lookup('username'),
      owner   => lookup('username'),
      require => Class['::profiles::gstack::grafana::base']
  }
  mysql::db { 'grafana-prime':
    user     => 'root',
    password => lookup('mysql_password'),
    require  => Class['::profiles::gstack::grafana::base']
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
        content => template('profiles/gstack/grafana/config.ini.erb'),
        owner   => lookup('username'),
        group   => lookup('username'),
        require => File['/opt/grafana/storage/prime/conf/']
  }
  supervisord::program {
    'grafana-prime':
      command   => '/opt/grafana/prime/bin/grafana-server --homepath=/opt/grafana/prime/ --config=/opt/grafana/storage/prime/conf/grafana.ini &',
      subscribe => File['/opt/grafana/storage/prime/conf/grafana.ini'],
      require   => [Exec['Extract Grafana prime'], File['/opt/grafana/storage/prime/conf/grafana.ini'] ]
  }
  exec {
    'restart-supervisord-prime' :
      path        => '/usr/bin:/usr/sbin:/bin',
      provider    => shell,
      command     => 'supervisorctl restart grafana-prime',
      subscribe   => [File['/opt/grafana/storage/prime/conf/grafana.ini']],
      require     => Supervisord::Program['grafana-prime'],
      refreshonly => true,
  }
}
