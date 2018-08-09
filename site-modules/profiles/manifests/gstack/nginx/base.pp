# Class profiles::gstack::nginx::base
class profiles::gstack::nginx::base (
  $nginx_username = lookup('profiles::gstack::general_setting::username')
){
  class { 'nginx' :
      daemon_user => $nginx_username,
  }
}
