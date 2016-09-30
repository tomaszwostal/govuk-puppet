# == Class: Govuk::Node::S_kube_master
#
# Create a Kubernetes master
#
class govuk::node::s_kube_master {
    include govuk::node::s_base

    include govuk_kubernetes::master
}
