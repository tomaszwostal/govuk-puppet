# == Class: Govuk_kubernetes::User
#
# What needs doing:
# - a user who can run the kubernetes binaries
# - a user on the master who is able to SSH using keys to the nodes
#
class govuk_kubernetes::user {
  user { 'kubenetes':
    ensure     => present,
    home       => '/home/kubernetes',
    managehome => 'true',
  }
}
