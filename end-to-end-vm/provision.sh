#!/bin/sh
#
# clone_or_update()
# {
#   if [ -d $1 ]
#   then
#     git -C $1 pull
#   else
#     git clone $2
#   fi
# }
#
# sudo mkdir /var/govuk
# sudo chown `whoami`:`whoami` /var/govuk
# cd /var/govuk
# clone_or_update govuk-puppet https://github.com/alphagov/govuk-puppet.git
# cd govuk-puppet
# bundle install
# bundle exec rake librarian:install
# /var/govuk/govuk-puppet/tools/puppet-apply


sudo chown `whoami`:`whoami` /var/govuk
/var/govuk/govuk-puppet/tools/puppet-apply-dev
