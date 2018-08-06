# Class profiles::gstack::graphite::base
class profiles::gstack::graphite::base (

){
  include ::profiles::gstack::base
  include ::profiles::gstack::base::setuptools
  include ::profiles::gstack::base::supervisor
  $graphiteversion = '1.0.2'
  $check_whisper = "pip show whisper | grep ${graphiteversion}"
  $check_carbon = "cat /opt/graphite/lib/carbon-${graphiteversion}-*/PKG-INFO | grep 'Version:' | grep -v 'Meta' | grep ${graphiteversion}"
  $check_graphite_web = "cat /opt/graphite/webapp/graphite_web-${graphiteversion}-*/PKG-INFO | grep 'Version:' | grep ${graphiteversion}"
  #region Install Mandatory Packages
  ensure_packages(['cairo-devel'])
  file { '/opt/graphite/requirements.txt' :
    ensure  => file,
    content => template('profiles/gstack/graphite/conf/requirements.txt.erb')
  }
  exec { 'Install-Graphite-Pip-Requirements' :
    path        => '/usr/bin:/usr/sbin:/bin',
    provider    => shell,
    command     => 'pip install -r /opt/graphite/requirements.txt',
    subscribe   => File['/opt/graphite/requirements.txt'],
    refreshonly => true
  }
  #endregion
  #region Create required folders
  file { ['/opt/graphite/','/opt/graphite/storage','/opt/data/graphite','/opt/data/graphite/storage/'] :
      ensure  => directory,
      group   => lookup('username'),
      owner   => lookup('username'),
      require => User['grafana_user'],
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
    unless      => [ $check_whisper ],
    require     => [
      Archive["/opt/puppet/packages/whisper-${graphiteversion}.tar.gz"],
      Class['::profiles::gstack::base::setuptools']
    ],
  }
  exec { 'Install-Graphite-Carbon':
    environment => ["PYTHONPATH='/opt/graphite/lib/:/opt/graphite/webapp/'"],
    path        => '/bin/:/sbin/:/usr/bin/:/usr/sbin/:/usr/local/bin/',
    command     => "pip install --no-binary=:all: /opt/puppet/packages/carbon-${graphiteversion}.tar.gz",
    unless      => [ $check_carbon ],
    require     => [
      Archive["/opt/puppet/packages/carbon-${graphiteversion}.tar.gz"],
      Class['::profiles::gstack::base::setuptools']
    ],
  }
  exec { 'Install-Graphite-Graphite-Web':
    environment => ["PYTHONPATH='/opt/graphite/lib/:/opt/graphite/webapp/'"],
    path        => '/bin/:/sbin/:/usr/bin/:/usr/sbin/:/usr/local/bin/',
    command     => "pip install --no-binary=:all: /opt/puppet/packages/graphite-web-${graphiteversion}.tar.gz",
    unless      => [ $check_graphite_web ],
    require     => [
      Archive["/opt/puppet/packages/graphite-web-${graphiteversion}.tar.gz"] ,
      Class['::profiles::gstack::base::setuptools']
    ],
  }
  #endregion
}
