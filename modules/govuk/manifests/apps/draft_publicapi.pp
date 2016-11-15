# Configures a draft API that exposes the draft content store
class govuk::apps::draft_publicapi (
  $privateapi_ssl = true,
) {

  $app_domain = hiera('app_domain')

  $content_store_api = "draft-content-store.${app_domain}"

  if ($privateapi_ssl) {
    $privateapi_protocol = 'https'
  } else {
    $privateapi_protocol = 'http'
  }

  $app_name = 'draft-publicapi'
  $full_domain = "${app_name}.${app_domain}"

  nginx::config::vhost::proxy { $full_domain:
    to               => [$content_store_api],
    to_ssl           => $privateapi_ssl,
    protected        => false,
    ssl_only         => false,
    extra_app_config => "
      # Don't proxy_pass / anywhere, just return 404. All real requests will
      # be handled by the location blocks below.
      return 404;
    ",
    extra_config     => template('govuk/draft_publicapi_nginx_extra_config.erb'),
  }
}
