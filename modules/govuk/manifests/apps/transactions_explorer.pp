class govuk::apps::transactions_explorer {
  $app_domain = extlookup('app_domain')
  $app_name = 'transactions-explorer'
  $vhost_full = "${app_name}.${app_domain}"
  $app_path = "/data/vhost/${app_name}"

  $te_root = "${app_name}.${app_domain}"

  $logpath = '/var/log/nginx'
  $access_log = "${app_name}-access.log"
  $json_access_log = "${app_name}-json.event.access.log"
  $error_log = "${app_name}-error.log"

  # Whether to enable SSL. Used by template.
  $enable_ssl = str2bool(extlookup('nginx_enable_ssl', 'yes'))
  # Whether to enable basic auth protection. Used by template.
  $enable_basic_auth = str2bool(extlookup('nginx_enable_basic_auth', 'yes'))

  include govuk::deploy

  govuk::app::package { $app_name:
    vhost_full => $vhost_full,
  }

  nginx::config::site { $te_root:
    content => template('nginx/transactions-explorer-vhost.conf'),
  }
}