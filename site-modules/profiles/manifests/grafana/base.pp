class profiles::grafana::base {  
  $grafanaversion = "5.1.3"
  file { 
    ['/opt/puppet/packages/','/opt/grafana/','/opt/grafana/storage'] :
      ensure  => directory,
      group   => lookup('username'),
      owner   => lookup('username'),
      require => User['Grafana User'],
  }
  archive { 
    "/opt/puppet/packages/grafana-${grafanaversion}.tar.gz":
      ensure          => present,
      extract         => false,
      source          => "https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-${grafanaversion}.linux-x64.tar.gz",
      user            => lookup('username'),
      group           => lookup('username'),
      cleanup         => true,
      require         => File['/opt/puppet/packages'],
  }
}
