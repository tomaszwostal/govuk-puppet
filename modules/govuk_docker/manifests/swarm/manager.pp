# == Define: Govuk_docker::Swarm::Manager
#
# Assign a node to be manager of a swarm cluster
#
define govuk_docker::swarm::manager (
  $cluster_name,
  $etcd_endpoint = 'etcd',
) {
  package { 'etcdctl':
    ensure => 'present',
  }

  $etcd_cmd = "ETCDCTL_API=3 etcdctl --endpoints=${etcd_endpoint}:2379"
  $add_node_value = "${cluster_name}_manager_ip"

  exec { 'Add manager IP address':
    command => "${etcd_cmd} put ${add_node_value} ${::ipaddress_eth0}",
    unless  => "${etcd_cmd} get ${add_node_value} |grep ${::ipaddress_eth0}"
    path    => '/usr/local/bin/:/bin/',
    require => Package['etcdctl'],
  }

  docker::swarm { "${cluster_name}_manager_${::hostname}":
    init           => true,
    advertise_addr => $::ipaddress_eth0,
    listen_addr    => $::ipaddress_eth0,
    require        => Exec['Add manager IP address'],
  }
}
