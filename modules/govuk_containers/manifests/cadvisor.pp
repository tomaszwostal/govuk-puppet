# == Class: govuk_containers::cadvisor
#
class govuk_containers::cadvisor {

  include ::docker

  $image_name = 'google/cadvisor'
  $image_version = 'v0.23.1'

  ::docker::image { $image_name:
    ensure    => 'present',
    image_tag => $image_version,
    require   => Class['docker'],
  }

  ::docker::run { 'cadvisor':
    image   => "${image_name}:${image_version}",
    ports   => ['8080:8080'],
    require => Docker::Image[$image_name],
    detatch => true,
    volumes => [
      '/:/rootfs:ro',
      '/var/run:/var/run:rw',
      '/sys:/sys:ro',
      '/var/lib/docker/:/var/lib/docker:ro',
    ],
  }

  @@icinga::check { "check_cadvisor_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!/usr/bin/cadvisor',
    service_description => 'cadvisor running',
    host_name           => $::fqdn,
  }

}
