# Class profiles::grafanastack::grafana::base
class profiles::grafanastack::grafana::base {
  include ::profiles::grafanastack::base
  include ::profiles::grafanastack::base::mysql
  $grafanaversion = '5.1.3'
  file {
    ['/opt/grafana/','/opt/grafana/storage'] :
      ensure  => directory,
      group   => lookup('username'),
      owner   => lookup('username'),
      require => User['Grafana User'],
  }
  archive {
    "/opt/puppet/packages/grafana-${grafanaversion}.tar.gz":
      ensure  => present,
      extract => false,
      source  => "https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-${grafanaversion}.linux-x64.tar.gz",
      user    => lookup('username'),
      group   => lookup('username'),
      cleanup => true,
      require => [File['/opt/puppet/packages/'], Class['::profiles::grafanastack::base'], Class['::profiles::grafanastack::base::mysql']],
  }
}
