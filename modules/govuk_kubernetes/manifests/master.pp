# == Class: Govuk_kubernetes::Master
#
# Hopefully there is a better way to install Kubernetes across the master
# and nodes
#
class govuk_kubernetes::master {
  include govuk_kubernetes::package
  include govuk_kubernetes::user

  file {'/home/kubernetes/lazy_install.sh':
    ensure  => present,
    content => template('govuk_kubernetes/lazy_install.sh.erb'),
    owner   => 'kubernetes',
    mode    => '0755',
  }
  #
  #  exec { 'install kubernetes':
  #    command => '/home/kubernetes/lazy_install.sh',
  #    user    => 'kubernetes',
  #    unless  => 'test -f /etc/kubernetes/installed',
  #    require => File['/home/kubernetes/lazy_install.sh'],
  #  }
}
