# Class: profiles::gstack::grafana::alert
#
#
class profiles::gstack::grafana::alert (
  String $grafanauser     = lookup('profiles::gstack::general_settings::username'),
  String $grafanaversion  = lookup('profiles::gstack::grafana::version'),
  String $supervisor_cmd  = lookup('profiles::gstack::grafana::alert::command'),
  Hash   $cfg             = lookup('profiles::gstack::grafana::alert::cfg'),
  String $mysql_username  = lookup('profiles::gstack::mysql::root_username'),
  String $mysql_password  = lookup('profiles::gstack::mysql::root_password'),
) {
  include ::profiles::gstack::base
  include ::profiles::gstack::grafana::base
  file {
    ['/opt/grafana/alert/','/opt/grafana/storage/alert/','/opt/grafana/storage/alert/conf'] :
      ensure  => directory,
      group   => $grafanauser,
      owner   => $grafanauser ,
      require => Class['::profiles::gstack::grafana::base']
  }
  mysql::db { 'grafana-alert':
    user     => $mysql_username,
    password => $mysql_password,
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
        owner   => $grafanauser,
        group   => $grafanauser,
        require => File['/opt/grafana/storage/alert/conf/']
  }
  supervisord::program {
    'grafana-alert':
      command   => $supervisor_cmd,
      subscribe => File['/opt/grafana/storage/alert/conf/grafana.ini'],
      require   => [Exec['Extract Grafana alert'], File['/opt/grafana/storage/alert/conf/grafana.ini'], Mysql::Db['grafana-alert'] ]
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
