# == Define: Rds::Mysql::Db
#
# Defined type to manage a MySQL database in RDS
#
define rds::mysql::db (
  $rds_hostname,
  $root_user,
  $root_password,
  $config_dir = '/root/mysql',
) {

  file { $config_dir:
    ensure => 'directory',
  }

  $config_file = "${config_dir}/${title}.mysql.cnf"

  # Create a config file to deal with authentication
  file { $config_file:
    ensure  => 'present',
    content => template('rds/mysql.cnf.erb'),
    require => File[$config_dir],
  }

  $mysql_cmd = "/usr/bin/mysql --defaults-file=${config_file}"

  exec { 'Create database':
    command => "$mysql_cmd -e 'CREATE DATABASE ${title}'",
    unless  => "$mysql_cmd -e -e "show databases" |egrep -q '^${title}$'",
    require => File[$config_file],
  }
}
