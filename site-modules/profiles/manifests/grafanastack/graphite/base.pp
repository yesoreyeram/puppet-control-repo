# Class: profiles::grafanastack::graphite::base
#
#
class profiles::grafanastack::graphite::base {
  include ::profiles::grafanastack::base
  $graphiteversion = '1.0.2'
  #region Create required folders
  file { ['/opt/graphite/','/opt/graphite/storage'] :
      ensure  => directory,
      group   => lookup('username'),
      owner   => lookup('username'),
      require => User['Grafana User'],
  }
  #endregion
  #region Download packages
  archive { "/opt/puppet/packages/whisper-${graphiteversion}.tar.gz":
      ensure  => present,
      extract => false,
      source  => "https://github.com/graphite-project/whisper/tarball/${graphiteversion}",
      user    => lookup('username'),
      group   => lookup('username'),
      cleanup => true,
      require => File['/opt/puppet/packages/'],
  }
  archive { "/opt/puppet/packages/carbon-${graphiteversion}.tar.gz":
      ensure  => present,
      extract => false,
      source  => "https://github.com/graphite-project/carbon/tarball/${graphiteversion}",
      user    => lookup('username'),
      group   => lookup('username'),
      cleanup => true,
      require => File['/opt/puppet/packages/'],
  }
  archive { "/opt/puppet/packages/graphite-web-${graphiteversion}.tar.gz":
      ensure  => present,
      extract => false,
      source  => "https://github.com/graphite-project/graphite-web/tarball/${graphiteversion}",
      user    => lookup('username'),
      group   => lookup('username'),
      cleanup => true,
      require => File['/opt/puppet/packages/'],
  }
  #endregion
  #region Install Pip packages
  exec { 'Install-Graphite-Whisper':
    environment => ["PYTHONPATH='/opt/graphite/lib/:/opt/graphite/webapp/'"],
    path        => '/bin/:/sbin/:/usr/bin/:/usr/sbin/:/usr/local/bin/',
    command     => "pip install --no-binary=:all: /opt/puppet/packages/whisper-${graphiteversion}.tar.gz",
    require     => [ Archive["/opt/puppet/packages/whisper-${graphiteversion}.tar.gz"] , Class['::profiles::grafanastack::base'] ],
  }
  exec { 'Install-Graphite-Carbon':
    environment => ["PYTHONPATH='/opt/graphite/lib/:/opt/graphite/webapp/'"],
    path        => '/bin/:/sbin/:/usr/bin/:/usr/sbin/:/usr/local/bin/',
    command     => "pip install --no-binary=:all: /opt/puppet/packages/carbon-${graphiteversion}.tar.gz",
    require     => [ Archive["/opt/puppet/packages/carbon-${graphiteversion}.tar.gz"] , Class['::profiles::grafanastack::base'] ],
  }
  exec { 'Install-Graphite-Graphite-Web':
    environment => ["PYTHONPATH='/opt/graphite/lib/:/opt/graphite/webapp/'"],
    path        => '/bin/:/sbin/:/usr/bin/:/usr/sbin/:/usr/local/bin/',
    command     => "pip install --no-binary=:all: /opt/puppet/packages/graphite-web-${graphiteversion}.tar.gz",
    require     => [ Archive["/opt/puppet/packages/graphite-web-${graphiteversion}.tar.gz"] , Class['::profiles::grafanastack::base'] ],
  }
  #endregion
}
