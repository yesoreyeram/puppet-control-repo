# Class profiles::gstack::base::supervisor
class profiles::gstack::base::supervisor {
  include profiles::gstack::base
  include ::profiles::gstack::base::pip
  file { '/opt/data/log/supervisor/' :
    ensure  => directory,
    require => File['/opt/data/log/']
  }
  class { 'supervisord' :
    unix_socket          => false,
    inet_server          => true,
    inet_server_hostname => lookup('privateip'),
    inet_server_port     => '9001',
    inet_auth            => true,
    inet_username        => 'superuser',
    inet_password        => 'superpass',
    require              => Class['::profiles::gstack::base::pip']
  }
}
