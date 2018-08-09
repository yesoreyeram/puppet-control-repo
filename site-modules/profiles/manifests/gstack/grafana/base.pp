# Class: profiles::gstack::grafana::base
#
#
class profiles::gstack::grafana::base (
  String $grafanauser          = lookup('profiles::gstack::general_setting::username'),
  String $grafanaversion       = lookup('profiles::gstack::grafana::version'),
  String $grafana_download_url = lookup('profiles::gstack::grafana::download_url'),
  String $packages_dir         = lookup('profiles::gstack::general_setting::location::packages_dir'),
) {
  file {
    ['/opt/grafana/','/opt/grafana/storage'] :
      ensure  => directory,
      group   => $grafanauser,
      owner   => $grafanauser,
      require => [ User['grafana_user'], Class['::profiles::gstack::base'], Class['::profiles::gstack::base::mysql'] ],
  }
  archive {
    "${$packages_dir}/grafana-${grafanaversion}.tar.gz":
      ensure  => present,
      extract => false,
      source  => $grafana_download_url,
      user    => $grafanauser,
      group   => $grafanauser,
      cleanup => true,
      require => [File["${packages_dir}"], Class['::profiles::gstack::base'], Class['::profiles::gstack::base::mysql']],
  }
}
