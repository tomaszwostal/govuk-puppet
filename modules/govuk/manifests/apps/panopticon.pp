# == Class: govuk::apps::panopticon
#
# Legacy app that holds content.
# Read more: https://github.com/alphagov/panopticon
#
# === Parameters
#
# [*port*]
#   The port that panopticon API is served on.
#   Default: 3003
#
# [*rabbitmq_hosts*]
#   RabbitMQ hosts to connect to.
#   Default: localhost
#
# [*rabbitmq_user*]
#   RabbitMQ username.
#   Default: panopticon
#
# [*rabbitmq_password*]
#   RabbitMQ password.
#   Default: panopticon
#
class govuk::apps::panopticon(
  $port = '3003',
  $rabbitmq_hosts = 'localhost',
  $rabbitmq_user = 'panopticon',
  $rabbitmq_password = 'panopticon',
) {
  govuk::app { 'panopticon':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }

  Govuk::App::Envvar {
    app => 'panopticon',
  }

  govuk::app::envvar {
    "${title}-RABBITMQ_HOSTS":
      varname => 'RABBITMQ_HOSTS',
      value   => $rabbitmq_hosts;
    "${title}-RABBITMQ_VHOST":
      varname => 'RABBITMQ_VHOST',
      value   => '/';
    "${title}-RABBITMQ_USER":
      varname => 'RABBITMQ_USER',
      value   => $rabbitmq_user;
    "${title}-RABBITMQ_PASSWORD":
      varname => 'RABBITMQ_PASSWORD',
      value => $rabbitmq_password;
  }

  govuk::logstream { 'panopticon-org-import-json-log':
    logfile => '/var/apps/panopticon/log/organisation_import.json.log',
    fields  => {'application' => 'panopticon'},
    json    => true,
  }
}
