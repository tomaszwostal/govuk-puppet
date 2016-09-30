# == Class: Govuk_kubernetes::Package
#
# Install the packages required for a Kubernetes cluster
#
class govuk_kubernetes::package {
  package { ['docker.io', 'bridge-utils']:
    ensure => 'present',
  }

  service { 'docker':
    ensure => 'running',
  }
}
