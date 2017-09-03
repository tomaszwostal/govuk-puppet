# == Class: govuk::node::s_docker_backend
#
class govuk::node::s_docker_backend (
  $swarm_token = undef,
) {

  include ::govuk::node::s_base

  include ::govuk_containers::frontend::haproxy
  include ::govuk_containers::apps::release

  govuk_docker::swarm::worker { "backend_cluster_${::hostname}":
    cluster_name => 'backend_cluster',
    token        => $swarm_token,
  }

}
