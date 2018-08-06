# Class profiles::base
class profiles::base (
  Array[String] $enhancer_packages = lookup('profiles::gstack::general_setting::enhancer_packages')
) {
  ensure_packages( $enhancer_packages ,{
      ensure => present,
  })
}
