# Class profiles::gstack::nginx::graphite_web
#
#
class profiles::gstack::nginx::graphite_web (
  $nginx_username = lookup('profiles::gstack::general_setting::username')
){
  include ::profiles::gstack::nginx::base
  selinux::port {
    'allow-graphite-8888' :
      ensure   => 'present',
      seltype  => 'http_port_t',
      protocol => 'tcp',
      port     => 8888,
  }
  ::nginx::resource::server { 'graphitewebserver' :
    ensure               => present,
    server_name          => ['_'],
    listen_port          => 8888,
    client_max_body_size => '64M',
    use_default_location => false,
    locations            => {
      '^~ /static/'  =>  {
        location_cfg_append => {
          root       => '/usr/share/pyshared/django/contrib/admin',
          access_log => 'off',
        }
      },
      '^~ /content/' =>  {
        location_cfg_append => {
          root       => '/opt/graphite/webapp/',
          access_log => 'off',
        },
        expires             => '30d',
      },
      '/'            => {
        proxy_set_header    => ['Host $http_host','X-Real-IP $remote_addr'],
        location_cfg_append => {
          proxy_pass_header     => 'Server',
          proxy_redirect        =>'off',
          proxy_connect_timeout => 10,
          proxy_read_timeout    => 60,
          proxy_pass            => 'http://unix:/var/run/graphite.sock',
        }
      }
    },
    require              => [
      Selinux::Port['allow-graphite-8888']
    ],
  }
}
