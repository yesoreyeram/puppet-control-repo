# Class: profiles::gstack::grafana::prime
#
#
class profiles::gstack::grafana::prime (
  String $grafanauser     = lookup('profiles::gstack::general_settings::username'),
  String $grafanaversion  = lookup('profiles::gstack::grafana::version'),
  String $supervisor_cmd  = lookup('profiles::gstack::grafana::prime::command'),
  Hash   $cfg             = lookup('profiles::gstack::grafana::prime::cfg'),
  String $mysql_username  = lookup('profiles::gstack::mysql::root_username'),
  String $mysql_password  = lookup('profiles::gstack::mysql::root_password'),
) {
  include ::profiles::gstack::base
  include ::profiles::gstack::grafana::base
  file {
    ['/opt/grafana/prime/','/opt/grafana/storage/prime/','/opt/grafana/storage/prime/conf'] :
      ensure  => directory,
      group   => $grafanauser,
      owner   => $grafanauser ,
      require => Class['::profiles::gstack::grafana::base']
  }
  mysql::db { 'grafana-prime':
    user     => $mysql_username,
    password => $mysql_password,
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
        owner   => $grafanauser,
        group   => $grafanauser,
        require => File['/opt/grafana/storage/prime/conf/']
  }
  supervisord::program {
    'grafana-prime':
      command   => $supervisor_cmd,
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
