# == Define: Govuk_docker::Swarm::Worker
#
# Join a worker node to a Swarm cluster.
#
define govuk_docker::swarm::worker (
  $cluster_name,
  $token,
) {

  package { 'etcdctl':
    ensure => 'present',
  }

  # I cannot think how to assign this value to a variable in Puppet; perhaps
  # writing a set of functions is the way to go.
  $manager_ip = generate("/bin/bash", "-c", "/usr/local/bin/etcdctl --print-value-only get ${cluster_name}_manager_ip")

  docker::swarm {"${cluster_name}_worker_${::hostname}":
    join           => true,
    advertise_addr => $::ipaddress_eth0,
    listen_addr    => $::ipaddress_eth0,
    manager_ip     => $manager_ip,
    token          => $token,
  }
}
