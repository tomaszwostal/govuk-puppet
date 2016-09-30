# == Class: Govuk::Node::S_kube_node
#
# Create a Kubernetes node
#
class govuk::node::s_kube_node {
    include govuk::node::s_base

    include govuk_kubernetes::node
}
