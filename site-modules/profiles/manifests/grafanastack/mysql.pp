# Class: profiles::grafanastack::mysql
#
#
class profiles::grafanastack::mysql {
  class { '::mysql::server':
    root_password           => lookup('mysql_password'),
  }
}
