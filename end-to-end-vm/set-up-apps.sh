#!/bin/sh

clone_or_update()
{
  if [ -d $1 ]
  then
    git -C $1 fetch origin
  else
    git clone $2
  fi
  git -C $1 checkout $3
}

cd /var/govuk

clone_or_update publishing-api git@github.com:alphagov/publishing-api.git master
cd publishing-api
bundle install --quiet
bundle exec rake db:setup
cd ..

clone_or_update govuk-content-schemas git@github.com:alphagov/govuk-content-schemas.git master
cd govuk-content-schemas
bundle install --quiet
cd ..

clone_or_update content-store git@github.com:alphagov/content-store.git master
cd content-store
bundle install --quiet
bundle exec rake db:purge
cd ..

clone_or_update router-api git@github.com:alphagov/router-api.git master
cd router-api
bundle install --quiet
bundle exec rake db:purge
cd ..

clone_or_update rummager git@github.com:alphagov/rummager.git master
cd rummager
bundle install --quiet
RUMMAGER_INDEX=all bundle exec rake rummager:migrate_index
cd ..

clone_or_update asset-manager git@github.com:alphagov/asset-manager.git master
cd asset-manager
bundle install --quiet
bundle exec rake db:purge
cd ..

clone_or_update email-alert-api git@github.com:alphagov/email-alert-api.git master
cd email-alert-api
bundle install --quiet
bundle exec rake db:setup
cd ..

clone_or_update specialist-publisher git@github.com:alphagov/specialist-publisher.git master
cd specialist-publisher
bundle install --quiet
bundle exec rake db:seed
cd ..

clone_or_update static git@github.com:alphagov/static.git master
cd static
bundle install --quiet
cd ..

clone_or_update specialist-frontend git@github.com:alphagov/specialist-frontend.git master
cd specialist-frontend
bundle install --quiet
cd ..

clone_or_update finder-frontend git@github.com:alphagov/finder-frontend.git master
cd finder-frontend
bundle install --quiet
cd ..

clone_or_update router git@github.com:alphagov/router.git master
cd router
go get github.com/tools/godep
cd ..

clone_or_update frontend git@github.com:alphagov/frontend.git master
cd frontend
bundle install --quiet
cd ..

clone_or_update development git@github.gds:gds/development.git master
cd development
bundle install --quiet

bowl specialist-publisher specialist-frontend finder-frontend router
