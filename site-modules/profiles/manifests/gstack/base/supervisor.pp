# Class profiles::gstack::base::supervisor
class profiles::gstack::base::supervisor {
  include ::profiles::gstack::base::pip
  class { 'supervisord':
    unix_socket          => false,
    inet_server          => true,
    inet_server_hostname => 'localhost',
    inet_server_port     => '9001',
    inet_auth            => true,
    inet_username        => 'superuser',
    inet_password        => 'superpass',
    require              => Class['::profiles::gstack::base::pip']
  }
}
