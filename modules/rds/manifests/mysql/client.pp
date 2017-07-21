# == Class: Rds::Mysql::Client
#
# Install MySQL client packages
#
class rds::mysql::client (
  $client_version = undef,
){

  if $client_version {
    $client_version = $client_version
  } else {
    $client_version = 'present'
  }

  package { 'mysql-client':
    ensure =>  $client_package,
  }

}
