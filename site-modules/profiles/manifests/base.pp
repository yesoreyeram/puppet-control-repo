# Class profiles::base
class profiles::base {
  ensure_packages(lookup('enhancer_packages'),{
      ensure => present,
  })
}
