# Class: profiles::gstack::base::mysql
#
#
class profiles::gstack::base::mysql (
  String $mysql_password = lookup('profiles::gstack::mysql::root_password')
){
  class { '::mysql::server':
    root_password           => $mysql_password,
  }
}
