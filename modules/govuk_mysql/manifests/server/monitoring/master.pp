# == Class: govuk_mysql::server::monitoring::master
#
# Monitor a mysql master
#
class govuk_mysql::server::monitoring::master inherits govuk_mysql::server::monitoring {
  Collectd::Plugin::Mysql['lazy_eval_workaround'] {
    master => true,
  }

  $nagios_mysql_password = hiera('mysql_nagios')

  govuk_mysql::user { 'nagios@localhost':
    password_hash => mysql_password($nagios_mysql_password),
    table         => '*.*',
    privileges    => ['REPLICATION CLIENT'],
  }
}
