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
      recurse => true,
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
      command  => "su - ${grafanauser} -c 'tar -xzvf /opt/puppet/packages/grafana-${grafanaversion}.tar.gz -C /opt/grafana/${instance_name} --strip-components=1'",
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
  file { "/etc/init.d/grafana-${instance_name}" :
    content => template('profiles/gstack/service/grafana.init.erb'),
    group   => $grafanauser,
    mode    => '0755',
    notify  => Service["grafana-${instance_name}"],
    owner   => $grafanauser,
  }
  service {
    "grafana-${instance_name}" :
      ensure   => running,
      enable   => true,
      name     => "grafana-${instance_name}",
      provider => 'redhat',
      require  => File["/etc/init.d/grafana-${instance_name}"],
  }
}
