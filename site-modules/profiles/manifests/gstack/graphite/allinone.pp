# Class profiles::gstack::graphite::allinone
class profiles::gstack::graphite::allinone (
  Hash $grweb_local_settings = lookup('profiles::gstack::graphite::allinone::graphite_web::local_settings'),
  Hash $carbon_conf_settings = lookup('profiles::gstack::graphite::allinone::graphite::carbon_conf_settings'),
  Tuple $whitelist_conf_settings = lookup('profiles::gstack::graphite::allinone::graphite::whitelist_conf_settings'),
){
  include ::profiles::gstack::graphite::base
  file { '/opt/graphite/webapp/graphite/local_settings.py':
    ensure  => file,
    content => template('profiles/gstack/opt/graphite/webapp/graphite/local_settings.py.erb'),
  }
  file { '/opt/graphite/conf/wsgi.py':
    ensure  => file,
    content => template('profiles/gstack/opt/graphite/conf/graphite.wsgi.py.erb'),
  }
  file { '/opt/graphite/conf/carbon.conf':
    ensure  => file,
    content => template('profiles/gstack/opt/graphite/conf/carbon.conf.erb'),
  }
  file { '/opt/graphite/conf/whitelist.conf':
    ensure  => file,
    content => template('profiles/gstack/opt/graphite/conf/whitelist.conf.erb'),
  }
}
