# Class: profiles::grafanastack::base::mysql
#
#
class profiles::grafanastack::base::mysql {
  class { '::mysql::server':
    root_password           => lookup('mysql_password'),
  }
}
