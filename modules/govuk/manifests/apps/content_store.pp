# == Class govuk::apps::content_store
#
# The central storage of published content on GOV.UK
#
# === Parameters
#
# [*port*]
#   The port the app will listen on.
#
# [*mongodb_nodes*]
#   Array of hostnames for the mongo cluster to use.
#
# [*mongodb_name*]
#   The mongo database to be used. Overriden in development
#   to be 'content_store_development'.
#
# [*vhost*]
#   Virtual host for this application.
#   Default: content-store
#
# [*default_ttl*]
#   The default cache timeout in seconds.
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*nagios_memory_warning*]
#   Memory use at which Nagios should generate a warning.
#
# [*nagios_memory_critical*]
#   Memory use at which Nagios should generate a critical alert.
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::content_store(
  $port = '3068',
  $mongodb_nodes,
  $mongodb_name,
  $vhost = 'content-store',
  $default_ttl = '1800',
  $publishing_api_bearer_token = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $errbit_api_key = '',
  $secret_key_base = undef,
  $sentry_dsn = undef,
) {
  $app_name = 'content-store'

  govuk::app { $app_name:
    app_type               => 'rack',
    port                   => $port,
    sentry_dsn             => $sentry_dsn,
    vhost_ssl_only         => true,
    health_check_path      => '/healthcheck',
    log_format_is_json     => true,
    vhost                  => $vhost,
    nagios_memory_warning  => $nagios_memory_warning,
    nagios_memory_critical => $nagios_memory_critical,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  govuk::app::envvar::mongodb_uri { $app_name:
    hosts    => $mongodb_nodes,
    database => $mongodb_name,
  }

  if $secret_key_base {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    }
  }

  if $::aws_migration {
    $app_domain_internal = hiera('app_domain_internal')

    govuk::app::envvar { "${title}-PLEK_SERVICE_ROUTER_API_URI":
      varname => 'PLEK_SERVICE_ROUTER_API_URI',
      value   => "https://router-api.${app_domain_internal}",
    }
  }

  govuk::app::envvar {
    "${title}-DEFAULT_TTL":
      varname => 'DEFAULT_TTL',
      value   => $default_ttl;
    "${title}-PUBLISHING_API_BEARER_TOKEN":
      varname => 'PUBLISHING_API_BEARER_TOKEN',
      value   => $publishing_api_bearer_token;
    "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
  }
}
