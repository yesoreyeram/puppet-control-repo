# Class profiles::gstack::graphite::allinone
class profiles::gstack::graphite::allinone (
  Hash $grweb_local_settings = lookup('profiles::gstack::graphite::allinone::graphite_web::local_settings'),
){
  include ::profiles::gstack::graphite::base
  file { '/opt/graphite/webapp/graphite/local_settings.py':
    ensure  => 'present',
    content => template('profiles/gstack/opt/graphite/webapp/graphite/local_settings.py.erb'),
  }
}
