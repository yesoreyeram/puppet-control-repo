# Define:  profiles::gstack::grafana::instance
#
define profiles::gstack::grafana::instance (
  String $instance_name,
  Hash   $cfg             = lookup("profiles::gstack::grafana::${instance_name}::cfg"),
  String $grafanauser     = lookup('profiles::gstack::general_settings::username'),
  String $grafanaversion  = lookup('profiles::gstack::grafana::version'),
  String $mysql_username  = lookup('profiles::gstack::mysql::root_username'),
  String $mysql_password  = lookup('profiles::gstack::mysql::root_password'),
) {
  include ::profiles::gstack::base
  include ::profiles::gstack::grafana::base
  include ::profiles::gstack::base::mysql
  file {
    ["/opt/grafana/${instance_name}/","/opt/grafana/storage/${instance_name}/","/opt/grafana/storage/${instance_name}/conf"] :
      ensure  => directory,
      group   => $grafanauser,
      owner   => $grafanauser ,
      require => Class['::profiles::gstack::grafana::base']
  }
  mysql::db { "grafana-${instance_name}" :
    user     => $mysql_username,
    password => $mysql_password,
    require  => Class['::profiles::gstack::grafana::base']
  }
  exec {
    "Extract Grafana ${instance_name}":
      path     => '/usr/bin:/usr/sbin:/bin',
      provider => shell,
      command  => "tar -xzvf /opt/puppet/packages/grafana-${grafanaversion}.tar.gz -C /opt/grafana/${instance_name} --strip-components=1",
      unless   => "cat /opt/grafana/${instance_name}/VERSION | grep ${grafanaversion}",
      require  => File["/opt/grafana/${instance_name}/"],
  }
  file {
    "/opt/grafana/storage/${instance_name}/conf/grafana.ini" :
        ensure  => file,
        content => template('profiles/gstack/grafana/config.ini.erb'),
        owner   => $grafanauser,
        group   => $grafanauser,
        require => File["/opt/grafana/storage/${instance_name}/conf/"]
  }
  supervisord::program {
    "grafana-${instance_name}" :
      command        => "/opt/grafana/${instance_name}/bin/grafana-server --homepath=/opt/grafana/${instance_name}/ --config=/opt/grafana/storage/${instance_name}/conf/grafana.ini &",
      stdout_logfile => '/opt/data/log/supervisor/%(program_name)s.log',
      stderr_logfile => '/opt/data/log/supervisor/%(program_name)s.log',
      user           => $grafanauser,
      autostart      => true,
      autorestart    => true,
      stopsignal     => 'QUIT',
      subscribe      => File["/opt/grafana/storage/${instance_name}/conf/grafana.ini"],
      require        => [
        Exec["Extract Grafana ${instance_name}"],
        File["/opt/grafana/storage/${instance_name}/conf/grafana.ini"],
        Mysql::Db["grafana-${instance_name}"]
      ]
  }
  exec {
    "restart-supervisord-${instance_name}" :
      path        => '/usr/bin:/usr/sbin:/bin',
      provider    => shell,
      command     => "supervisorctl restart grafana-${instance_name}",
      subscribe   => [File["/opt/grafana/storage/${instance_name}/conf/grafana.ini"]],
      require     => Supervisord::Program["grafana-${instance_name}"],
      refreshonly => true,
  }
}
