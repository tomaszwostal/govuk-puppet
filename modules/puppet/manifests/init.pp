class puppet {
  package { 'puppet':
    ensure   => '2.7.18',
    provider => gem;
  }

  file { '/etc/puppet/puppet.conf':
    ensure => present,
    mode   => '0644',
    source => 'puppet:///modules/puppet/etc/puppet/puppet.conf';
  }

  $first = fqdn_rand_fixed(30)
  $second = $first + 30
  cron { 'puppet':
    ensure  => present,
    user    => 'root',
    minute  => [$first, $second],
    command => '/usr/bin/puppet agent --onetime --no-daemonize';
  }

  service { 'puppet': # we're using cron, so we don't want the daemonized puppet agent
    ensure   => stopped,
    provider => base,
    pattern  => '/usr/bin/puppet agent$';
  }
}
