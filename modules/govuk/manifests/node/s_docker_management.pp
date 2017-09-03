# == Class: govuk::node::s_docker_management
#
class govuk::node::s_docker_management inherits govuk::node::s_base {

  include ::govuk_docker
  include ::govuk_containers::docker_security_bench
  include ::govuk_containers::etcd

  # I have no idea if a single instance can manage multiple clusters
  govuk_docker::swarm::manager { 'frontend_cluster':
    cluster_name => 'frontend_cluster',
  }

  govuk_docker::swarm::manager { 'backend_cluster':
    cluster_name => 'backend_cluster',
  }
}
