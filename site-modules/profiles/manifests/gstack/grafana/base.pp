# Class: profiles::gstack::grafana::base
#
#
class profiles::gstack::grafana::base (
  String $grafanauser          = lookup('profiles::gstack::general_settings::username'),
  String $grafanaversion       = lookup('profiles::gstack::grafana::version'),
  String $grafana_download_url = lookup('profiles::gstack::grafana::download_url')
) {
  file {
    ['/opt/grafana/','/opt/grafana/storage'] :
      ensure  => directory,
      group   => $grafanauser,
      owner   => $grafanauser,
      require => [ User['grafana_user'], Class['::profiles::gstack::base'], Class['::profiles::gstack::base::mysql'] ],
  }
  archive {
    "/opt/puppet/packages/grafana-${grafanaversion}.tar.gz":
      ensure  => present,
      extract => false,
      source  => $grafana_download_url,
      user    => $grafanauser,
      group   => $grafanauser,
      cleanup => true,
      require => [File['/opt/puppet/packages/'], Class['::profiles::gstack::base'], Class['::profiles::gstack::base::mysql']],
  }
}
