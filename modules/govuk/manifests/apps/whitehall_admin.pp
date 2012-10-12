class govuk::apps::whitehall_admin( $port = 3026 ) {
  include users::assets

  govuk::app { 'whitehall-admin':
    app_type          => 'rack',
    port              => $port,
    health_check_path => '/healthcheck';
  }

  file { "/data/uploads":
    ensure  => 'directory',
    owner   => 'assets',
    group   => 'assets',
    mode    => '0664',
    require => [User['assets'], Group['assets']],
  }

  package { 'nfs-common':
    ensure => installed,
  }

  mount { "/data/uploads":
    ensure  => "mounted",
    device  => "asset-master.${::govuk_platform}.alphagov.co.uk:/mnt/uploads",
    fstype  => "nfs",
    options => "defaults",
    atboot  => true,
    require => [File["/data/uploads"], Package['nfs-common']],
  }

  @@nagios::check { "check_scheduled_publishing_${::hostname}":
    check_command       => "check_graphite_metric_since!hitcount(stats.govuk.app.whitehall.scheduled_publishing.call_rate,'16minutes')!16minutes!0.9:100!0.9:100",
    service_description => 'whitehall sched pub not run in prev 16m',
    use                 => 'govuk_urgent_priority',
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_no_overdue_scheduled_editions_${::hostname}":
    check_command       => "check_graphite_metric!stats.gauges.govuk.app.whitehall.scheduled_publishing.due!0!0",
    service_description => 'whitehall has overdue scheduled editions',
    use                 => 'govuk_urgent_priority',
    host_name           => "${::govuk_class}-${::hostname}",
  }
}
