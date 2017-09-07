# == Class: govuk::apps::need_api
#
# An application to maintain all the user needs for GOV.UK.  This presents an
# API for managing them.  See maslow for the UI that consumes this.
#
# === Parameters
#
# [*port*]
#   The port that publishing API is served on.
#   Default: 3093
#
# [*publishing_api_bearer_token*]
#   The bearer token to use when communicating with Publishing API.
#   Default: undef
#
# [*elasticsearch_hosts*]
#   A string of comma-separated list of Elasticsearch hosts,
#   for example: es-host-1:9200,es-host-2:9200
#
# [*sentry_dsn*]
#   The URL used by Sentry to report exceptions
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#   Default: ''
#
# [*mongodb_nodes*]
#   An array of MongoDB instance hostnames
#
# [*mongodb_name*]
#   The name of the MongoDB database to use
#
# [*oauth_id*]
#   Sets the OAuth ID for using GDS-SSO
#   Default: undef
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key for using GDS-SSO
#   Default: undef
#
# [*redis_host*]
#   The hostname of a Redis instance to connect to
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
class govuk::apps::need_api(
  $port = '3052',
  $publishing_api_bearer_token = undef,
  $elasticsearch_hosts = undef,
  $errbit_api_key = '',
  $sentry_dsn = undef,
  $mongodb_nodes,
  $mongodb_name = 'govuk_needs_production',
  $oauth_id = undef,
  $oauth_secret = undef,
  $redis_host = undef,
  $secret_key_base = undef,
) {
  govuk::app { 'need-api':
    ensure             => 'absent',
    app_type           => 'rack',
    port               => $port,
    sentry_dsn         => $sentry_dsn,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    repo_name          => 'govuk_need_api',
  }
}
