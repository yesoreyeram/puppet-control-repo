# Class: profiles::gstack::base::mysql
#
#
class profiles::gstack::base::mysql {
  class { '::mysql::server':
    root_password           => lookup('mysql_password'),
  }
}
