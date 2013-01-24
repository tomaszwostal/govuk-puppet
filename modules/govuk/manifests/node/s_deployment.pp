class govuk::node::s_deployment inherits govuk::node::s_base {
  include jenkins::master

  class { 'govuk::vpnc':
    dnsupdate => 'no',
  }

  host { 'github.gds':
    ip      => '192.168.9.110',
    comment => 'Ignore VPN DNS and set static host for GHE',
  }

  # Close connection if vhost not known
  nginx::config::vhost::default { 'default':
    status         => '444',
    status_message => '',
  }

  nginx::config::site { 'monitoring-proxy':
    content => template('jenkins/monitoring-proxy.conf.erb'),
  }
}
