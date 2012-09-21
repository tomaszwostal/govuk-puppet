class govuk_node::backend_load_balancer {
  include govuk_node::base

  include haproxy

  $backend_servers = {
    "backend-1" => "10.3.0.2",
    "backend-2" => "10.3.0.3",
    "backend-3" => "10.3.0.4",
  }

  haproxy::balance {'signon':
    servers           => $backend_servers,
    health_check_port => 9516,
    listen_port       => 8416,
  }
  #haproxy::balance {'contentapi':}
}
