# Class profiles::grafanastack::base::supervisor
class profiles::grafanastack::base::supervisor {
  include ::profiles::grafanastack::base::pip
  class { 'supervisord':
    unix_socket          => false,
    inet_server          => true,
    inet_server_hostname => lookup('privateip'),
    inet_server_port     => '9001',
    inet_auth            => false,
    inet_username        => undef,
    inet_password        => undef,
    require              => Class['::profiles::grafanastack::base::pip']
  }
}