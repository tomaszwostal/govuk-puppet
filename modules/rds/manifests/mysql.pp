# == Class: Rds::Mysql
#
# Base class for managing RDS MySQL instances. This should collect the
# resources from defined type and authenticate with the relevant database
# for processing.
#
class rds::mysql (
  include ::rds::mysql::client
}
