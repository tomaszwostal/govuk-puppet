# == Class: govuk::apps::spotlight
#
# Spotlight is a frontend application for the Performance Platform.
#
# === Parameters
#
# [*alert_5xx_warning_rate*]
#   The 5xx error percentage that should generate a warning
#
# [*alert_5xx_critical_rate*]
#   The 5xx error percentage that should generate a critical
#
# [*enabled*]
#   Should the app exist?
#
# [*port*]
#   What port should the app run on?

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
# [*backdrop_internal_url*]
#   App config, internal hostname for backdrop
#
# [*backdrop_public_url*]
#   App config, public hostname for backdrop
#
# [*stagecraft_url*]
#   App config, hostname for stagecraft
#
class govuk::apps::spotlight (
  $alert_5xx_warning_rate,
  $alert_5xx_critical_rate,
  $enabled = false,
  $port = '3057',
  $publishing_api_bearer_token = undef,
  $nagios_memory_warning = undef,
  $nagios_memory_critical = undef,
  $backdrop_internal_url = undef,
  $backdrop_public_url = undef,
  $stagecraft_url = undef,
) {
  $app_name = 'spotlight'

  if $enabled {
    govuk::app { $app_name:
      alert_5xx_warning_rate  => $alert_5xx_warning_rate,
      alert_5xx_critical_rate => $alert_5xx_critical_rate,
      app_type                => 'bare',
      command                 => '/usr/bin/node app/server',
      port                    => $port,
      vhost_ssl_only          => true,
      health_check_path       => '/_status',
      log_format_is_json      => true,
      nagios_memory_warning   => $nagios_memory_warning,
      nagios_memory_critical  => $nagios_memory_critical,
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar {
      "${title}-PUBLISHING_API_BEARER_TOKEN":
        varname => 'PUBLISHING_API_BEARER_TOKEN',
        value   => $publishing_api_bearer_token;
      "${title}-BACKDROP_INTERNAL_URL":
        varname => 'BACKDROP_INTERNAL_URL',
        value   => $backdrop_internal_url;
      "${title}-BACKDROP_PUBLIC_URL":
        varname => 'BACKDROP_PUBLIC_URL',
        value   => $backdrop_public_url;
      "${title}-STAGECRAFT_URL":
        varname => 'STAGECRAFT_URL',
        value   => $stagecraft_url;
    }
  }
}
