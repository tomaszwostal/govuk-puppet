class govuk::apps::search( $port = 3009 ) {
  include aspell

  # Enable raindrops monitoring
  collectd::plugin::raindrops { 'search':
    port => $port,
  }

  govuk::app { 'search':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/mainstream/search?q=search_healthcheck',
  }

  govuk::app::nginx_vhost { 'search':
    nginx_extra_config => '
    client_max_body_size 500m;
    '
  }

  govuk::delayed_job::worker { 'search': }
}
