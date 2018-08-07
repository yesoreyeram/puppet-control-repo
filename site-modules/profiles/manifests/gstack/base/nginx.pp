# Class profiles::gstack::nginx
class profiles::gstack::base::nginx (
  $nginx_username = lookup('profiles::gstack::general_settings::username')
){
  class { 'nginx' :
      daemon_user => $nginx_username,
  }
}
