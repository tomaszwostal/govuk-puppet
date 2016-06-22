# == Class: envdir
#
# Creates a file an directory structure for environment information when using env_dir command.
#
# === Variables
#
#
# [*user*]
#   The user running the env_dir command
#
# [*env_path*]
#   Directory that contains env_dir folders
#
# [*envname*]
#   Directory which contains files with environment variable content
#
# [*envar*]
#   Array containing environment hashes
#
# [*name*]
#   Name of the file which contains environment variables
#
# === Example
#
#  envdir { 'aws_access_key':
#   user    => 'govuk-backup',
#   envname => 's3backup',
#   envar  => '$some_hierahash',
#  }
#
# Author Name Mikael Allison
#
#
class envdir {


  define envdir(
    $user,
    $env_path = '/etc/env_dir/',
    $envname,
    $envar    = [],
    $name,
    ){


    file { [$env_path,"${env_path}/${envname}"]:
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0775',
    }

    file { "${name}":
      ensure  => file,
      path => "${env_path}/${envname}/${name}",
      content => $envar,
      owner   => $user,
      group   => $user,
      mode    => '0550',
    }

  }
}
