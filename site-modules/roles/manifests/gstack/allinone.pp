# Class roles::gstack::allinone 
class roles::gstack::allinone {
  #region Profiles
  include ::profiles::base
  include ::profiles::gstack::base
  include ::profiles::gstack::base::nginx
  include ::profiles::gstack::base::nodejs
  include ::profiles::gstack::base::python
  include ::profiles::gstack::base::pip
  include ::profiles::gstack::base::setuptools
  include ::profiles::gstack::base::supervisor
  include ::profiles::gstack::grafana::prime
  include ::profiles::gstack::grafana::alert
  include ::profiles::gstack::graphite::allinone
  #endregion
  #region Dependencies
  Class['::profiles::base']                     -> Class['::profiles::gstack::base']
  Class['::profiles::gstack::base']             -> Class['::profiles::gstack::base::nginx']
  Class['::profiles::gstack::base']             -> Class['::profiles::gstack::base::nodejs']
  Class['::profiles::gstack::base']             -> Class['::profiles::gstack::base::python']
  Class['::profiles::gstack::base::python']     -> Class['::profiles::gstack::base::pip']
  Class['::profiles::gstack::base::pip']        -> Class['::profiles::gstack::base::setuptools']
  Class['::profiles::gstack::base::pip']        -> Class['::profiles::gstack::base::supervisor']
  Class['::profiles::gstack::base::supervisor'] -> Class['::profiles::gstack::grafana::prime']
  Class['::profiles::gstack::base::supervisor'] -> Class['::profiles::gstack::grafana::alert']
  Class['::profiles::gstack::base::supervisor'] -> Class['::profiles::gstack::graphite::allinone']
  #endregion
}
