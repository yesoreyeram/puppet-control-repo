# Class profiles::gstack::base::supervisor
class profiles::gstack::base::supervisor (
  $super_user = lookup('profiles::gstack::supervisor::user'),
  $super_pass = lookup('profiles::gstack::supervisor::pass'),
){
  include profiles::gstack::base
  include ::profiles::gstack::base::pip
  file { '/opt/data/log/supervisor/' :
    ensure  => directory,
    require => File['/opt/data/log/']
  }
  class { 'supervisord' :
    unix_socket          => false,
    inet_server          => true,
    inet_server_hostname => 'localhost',
    inet_server_port     => '9001',
    inet_auth            => true,
    inet_username        => $super_user,
    inet_password        => $super_pass,
    require              => Class['::profiles::gstack::base::pip']
  }
}
