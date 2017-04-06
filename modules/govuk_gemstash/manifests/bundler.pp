# == Class: govuk_gemstash::bundler
#
# Manage the gemstash config used by bundler
#
# === Parameters
#
# [*server*]
#   The gemstash server to use
#
class govuk_gemstash::bundler(
  $server = 'http://127.0.0.1:9292',
) {

  file { '/home/deploy.bundle':
    ensure => 'directory',
  }

  file { '/home/deploy/.bundle':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }

  file { '/home/deploy/.bundle/config':
    owner   => 'root',
    group   => 'root',
    ensure  => 'present',
    mode    => '0644',
    content => template('govuk_gemstash/bundle_config.erb'),
  }

}
