# Class: profiles::grafana::alert
#
#
class profiles::grafana::alert {
  include ::profiles::grafanastack::base
  include ::profiles::grafana::base
  $grafanaversion = "5.1.3"
  $cfg = {
    server   => {
      http_port     => 3001,
    }
  }
  notify { 'Installing Grafana alert':
    require => Class['::profiles::grafanastack::base']
  }
  file { 
    ['/opt/grafana/alert/','/opt/grafana/storage/alert/','/opt/grafana/storage/alert/conf'] :
      ensure  => directory,
      group   => lookup('username'),
      owner   => lookup('username'),
      require  => Class['::profiles::grafana::base']
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
    "/opt/grafana/storage/alert/conf/grafana.ini":
        ensure  => file,
        content => template('profiles/grafana.config.ini.erb'),
        owner   => lookup('username'),
        group   => lookup('username')
  }
  supervisord::program { 
    'grafana-alert':
      command             => '/opt/grafana/alert/bin/grafana-server --homepath=/opt/grafana/alert/ --config=/opt/grafana/storage/alert/conf/grafana.ini &',
  }
}
