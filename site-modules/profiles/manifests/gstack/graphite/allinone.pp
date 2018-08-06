# Class profiles::gstack::graphite::allinone
class profiles::gstack::graphite::allinone (
  String  $graphiteuser               = lookup('profiles::gstack::general_settings::username'),
  Hash    $grweb_local_settings      = lookup('profiles::gstack::graphite::allinone::graphite_web::local_settings'),
  Hash    $carbon_conf_settings      = lookup('profiles::gstack::graphite::allinone::graphite::carbon_conf_settings'),
  Hash    $storage_schemas           = lookup('profiles::gstack::graphite::allinone::graphite::storage_schemas'),
  Hash    $storage_aggregation       = lookup('profiles::gstack::graphite::allinone::graphite::storage_aggregation'),
  Hash    $relay_rules               = lookup('profiles::gstack::graphite::allinone::graphite::relay_rules'),
  Tuple   $whitelist_conf_settings   = lookup('profiles::gstack::graphite::allinone::graphite::whitelist_conf_settings'),
){
  include ::profiles::gstack::graphite::base
  include ::profiles::gstack::base::memcached
  file { '/opt/graphite/webapp/graphite/local_settings.py' :
    ensure  => file,
    content => template('profiles/gstack/graphite/webapp/local_settings.py.erb'),
  }
  file { '/opt/graphite/conf/wsgi.py' :
    ensure  => file,
    content => template('profiles/gstack/graphite/conf/graphite.wsgi.py.erb'),
  }
  file { '/opt/graphite/conf/carbon.conf' :
    ensure  => file,
    content => template('profiles/gstack/graphite/conf/carbon.conf.erb'),
  }
  file { '/opt/graphite/conf/storage-schemas.conf' :
    ensure  => file,
    content => template('profiles/gstack/graphite/conf/storage-schemas.conf.erb'),
  }
  file { '/opt/graphite/conf/storage-aggregation.conf' :
    ensure  => file,
    content => template('profiles/gstack/graphite/conf/storage-aggregation.conf.erb'),
  }
  file { '/opt/graphite/conf/relay-rules.conf' :
    ensure  => file,
    content => template('profiles/gstack/graphite/conf/relay-rules.conf.erb'),
  }
  file { '/opt/graphite/conf/whitelist.conf' :
    ensure  => file,
    content => template('profiles/gstack/graphite/conf/whitelist.conf.erb'),
  }
  file { '/opt/graphite/conf/dashboard.conf' :
    ensure  => file,
    content => template('profiles/gstack/graphite/conf/dashboard.conf.erb'),
  }
  file { '/opt/graphite/conf/graphTemplates.conf' :
    ensure  => file,
    content => template('profiles/gstack/graphite/conf/graphTemplates.conf.erb'),
  }
  exec { 'Graphite-Web-Django-Admin-Migrate' :
      path        => '/usr/bin:/usr/sbin:/bin',
      provider    => shell,
      environment => ['PYTHONPATH=/opt/graphite/webapp/'],
      command     => 'django-admin migrate  --settings=graphite.settings',
      onlyif      => ['PYTHONPATH=/opt/graphite/webapp/ django-admin.py showmigrations --settings=graphite.settings | grep "\[\ \]"'],
      require     => [File['/opt/graphite/conf/wsgi.py'],File['/opt/graphite/webapp/graphite/local_settings.py']],
  }
  supervisord::program {
    'carbon-cache-a':
      command        => '/opt/graphite/bin/carbon-cache.py --instance=a --debug start',
      stdout_logfile => '/opt/data/log/supervisor/%(program_name)s.log',
      stderr_logfile => '/opt/data/log/supervisor/%(program_name)s.log',
      user           => $graphiteuser,
      autostart      => true,
      autorestart    => true,
      stopsignal     => 'QUIT',
  }
  supervisord::program {
    'carbon-cache-b':
      command        => '/opt/graphite/bin/carbon-cache.py --instance=b --debug start',
      stdout_logfile => '/opt/data/log/supervisor/%(program_name)s.log',
      stderr_logfile => '/opt/data/log/supervisor/%(program_name)s.log',
      user           => $graphiteuser,
      autostart      => true,
      autorestart    => true,
      stopsignal     => 'QUIT',
  }
  supervisord::program {
    'carbon-relay-a':
      command        => '/opt/graphite/bin/carbon-relay.py --instance=a --debug start',
      stdout_logfile => '/opt/data/log/supervisor/%(program_name)s.log',
      stderr_logfile => '/opt/data/log/supervisor/%(program_name)s.log',
      user           => $graphiteuser,
      autostart      => true,
      autorestart    => true,
      stopsignal     => 'QUIT',
  }
}
