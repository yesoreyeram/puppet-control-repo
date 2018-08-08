# Class profiles::gstack::graphite::uwsgi
class profiles::gstack::graphite::uwsgi (
  String  $graphiteuser = lookup('profiles::gstack::general_settings::username'),
  Hash $uwsgi_config    = lookup('profiles::gstack::graphite::allinone::graphite_web::uwsgi_config')
){
  include ::profiles::gstack::base
  include ::profiles::gstack::base::setuptools
  ensure_packages(['uwsgi','uwsgi-plugin-python'])
  file { ['/opt/data/uwsgi/','/etc/uwsgi.d/','/etc/uwsgi.d/apps-available/'] :
    ensure => directory,
    owner  => $graphiteuser,
    group  => $graphiteuser,
  }
  file { '/etc/uwsgi.d/apps-available/graphite.ini' :
    ensure  => file,
    content => template('profiles/gstack/graphite/uwsgi/uwsgi.ini.erb'),
    require => File['/etc/uwsgi.d/apps-available/']
  }
  supervisord::program { 'uwsgi' :
      command        => '/sbin/uwsgi --ini /etc/uwsgi.d/apps-available/graphite.ini --pidfile /opt/data/uwsgi/uwsgi.pid  --fastcgi-socket 127.0.0.1:5000',
      stdout_logfile => '/opt/data/log/supervisor/%(program_name)s.log',
      stderr_logfile => '/opt/data/log/supervisor/%(program_name)s.log',
      user           => $graphiteuser,
      autostart      => true,
      autorestart    => true,
      stopsignal     => 'QUIT',
  }
}
