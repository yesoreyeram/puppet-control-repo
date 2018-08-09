# Class roles::gstack::allinone
class roles::gstack::allinone {
  #region Profiles
  include ::profiles::base
  include ::profiles::gstack::base
  include ::profiles::gstack::graphite::allinone
  include ::profiles::gstack::grafana::instances
  include ::profiles::gstack::nginx::graphite_web
  #endregion
  #region Dependencies
  Class['::profiles::base']                       -> Class['::profiles::gstack::base']
  Class['::profiles::gstack::base']               -> Class['::profiles::gstack::graphite::allinone']
  Class['::profiles::gstack::base']               -> Class['::profiles::gstack::grafana::instances']
  Class['::profiles::gstack::graphite::allinone'] -> Class['::profiles::gstack::nginx::graphite_web']
  #endregion
}
