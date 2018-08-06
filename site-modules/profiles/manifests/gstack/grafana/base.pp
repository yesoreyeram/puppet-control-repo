# Class profiles::gstack::grafana::base
class profiles::gstack::grafana::base {
  include ::profiles::gstack::base
  include ::profiles::gstack::base::mysql
  $grafanaversion = lookup('grafana_version')
  file {
    ['/opt/grafana/','/opt/grafana/storage'] :
      ensure  => directory,
      group   => lookup('username'),
      owner   => lookup('username'),
      require => [ User['grafana_user'], Class['::profiles::gstack::base'], Class['::profiles::gstack::base::mysql'] ],
  }
  archive {
    "/opt/puppet/packages/grafana-${grafanaversion}.tar.gz":
      ensure  => present,
      extract => false,
      source  => "https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-${grafanaversion}.linux-x64.tar.gz",
      user    => lookup('username'),
      group   => lookup('username'),
      cleanup => true,
      require => [File['/opt/puppet/packages/'], Class['::profiles::gstack::base'], Class['::profiles::gstack::base::mysql']],
  }
}
