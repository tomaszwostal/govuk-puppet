# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::email_campaign_api(
  $port = 3110,
  $enabled = true,
  $errbit_api_key = undef,
  $secret_key_base = undef,
  $mongodb_nodes,
  $mongodb_name = 'email_campaign_api',
) {
  $app_name = 'email-campaign-api'

  if $enabled {
    govuk::app { $app_name:
      app_type           => 'rack',
      port               => $port,
      health_check_path  => '/healthcheck',
      log_format_is_json => true,
    }

    Govuk::App::Envvar {
      app => $app_name,
    }

    govuk::app::envvar::mongodb_uri { $app_name:
      hosts    => $mongodb_nodes,
      database => $mongodb_name,
    }

    if $errbit_api_key != undef {
      govuk::app::envvar {
        "${title}-ERRBIT_API_KEY":
          varname => 'ERRBIT_API_KEY',
          value   => $errbit_api_key;
      }
    }

    if $secret_key_base != undef {
      govuk::app::envvar { "${title}-SECRET_KEY_BASE":
        varname => 'SECRET_KEY_BASE',
        value   => $secret_key_base,
      }
    }
  }
}
