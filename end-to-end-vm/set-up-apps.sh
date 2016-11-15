#!/bin/bash

set -e

clone_or_update()
{
  if [ -d $1 ]
  then
    if ! git -C $1 diff --quiet --ignore-submodules --no-ext-diff; then
      echo "skipped updating $1 due to local changes"
    else
      if ! git -C $1 checkout $3; then
        echo "git failed to checked $3"
      fi
      if ! git -C $1 fetch origin; then
        echo "git fetch failed for $1"
        exit 1
      fi
      if ! git -C $1 merge --ff-only origin/$3; then
        echo "updating $1 failed"
        exit 1
      fi
    fi
  else
    git clone -b $3 $2
  fi
}

kill_if_pidfile()
{
  if [ -f $1 ] && ps -p $(cat $1) > /dev/null
  then
    kill -9 $(cat $1)
  fi
}

govuk_setenv_daemon()
{
  govuk_setenv $1 start-stop-daemon --start --startas "/bin/sh" --pid $2 --chdir . -- -c "$3"
}

govuk_setenv_daemon_background()
{
  govuk_setenv $1 start-stop-daemon --start --startas "/bin/sh" --make-pid --pid $2 --chdir . --background -- -c "$3"
}
cd /var/govuk

clone_or_update publishing-e2e-tests git@github.com:kevindew/publishing-e2e-tests.git ${PUBLISHING_E2E_TESTS_BRANCH:-"master"}
cd publishing-e2e-tests
bundle install --quiet
cd ..

clone_or_update govuk-content-schemas git@github.com:alphagov/govuk-content-schemas.git ${GOVUK_CONTENT_SCHEMAS_BRANCH:-"master"}
cd govuk-content-schemas
bundle install --quiet
cd ..

clone_or_update content-store git@github.com:alphagov/content-store.git ${CONTENT_STORE_BRANCH:-"master"}
cd content-store
bundle install --quiet
kill_if_pidfile tmp/pids/server.pid
kill_if_pidfile tmp/pids/draft-server.pid
govuk_setenv content-store bundle exec rake db:purge
govuk_setenv_daemon content-store tmp/pids/server.pid "bundle exec rails s -p 3068 -d"
govuk_setenv draft-content-store bundle exec rake db:purge
govuk_setenv_daemon draft-content-store tmp/pids/draft-server.pid "bundle exec rails s -p 3100 -P tmp/pids/draft-server.pid -d"
cd ..

clone_or_update router-api git@github.com:alphagov/router-api.git ${ROUTER_API_BRANCH:-"master"}
cd router-api
bundle install --quiet
kill_if_pidfile tmp/pids/server.pid
govuk_setenv router-api bundle exec rake db:purge
govuk_setenv_daemon router-api tmp/pids/server.pid "bundle exec rails s -p 3056 -d"
cd ..

clone_or_update publishing-api git@github.com:alphagov/publishing-api.git ${PUBLISHING_API_BRANCH:-"master"}
cd publishing-api
bundle install --quiet
kill_if_pidfile tmp/pids/sidekiq.pid
kill_if_pidfile tmp/pids/server.pid
govuk_setenv publishing-api bundle exec rake db:setup
govuk_setenv_daemon publishing-api tmp/pids/sidekiq.pid "bundle exec sidekiq -C ./config/sidekiq.yml -P tmp/pids/sidekiq.pid -d"
govuk_setenv_daemon publishing-api tmp/pids/server.pid "bundle exec rails s -p 3093 -d"
cd ..

clone_or_update rummager git@github.com:alphagov/rummager.git ${RUMMAGER_BRANCH:-"master"}
cd rummager
bundle install --quiet
kill_if_pidfile /tmp/rummager-sidekiq.pid
kill_if_pidfile /tmp/rummager-mq-publishing-queue.pid
kill_if_pidfile /tmp/rummager-server.pid
RUMMAGER_INDEX=all govuk_setenv rummager bundle exec rake rummager:migrate_index
govuk_setenv_daemon rummager /tmp/rummager-sidekiq.pid "bundle exec sidekiq -C ./config/sidekiq.yml -P /tmp/rummager-sidekiq.pid -d"
govuk_setenv_daemon_background rummager /tmp/rummager-mq-publishing-queue.pid "bundle exec rake message_queue:listen_to_publishing_queue &> log/publishing-queue.log"
govuk_setenv_daemon_background rummager /tmp/rummager-server.pid "bundle exec bundle exec mr-sparkle --force-polling -- -p 3009"
cd ..

clone_or_update asset-manager git@github.com:alphagov/asset-manager.git ${ASSET_MANAGER_BRANCH:-"master"}
cd asset-manager
bundle install --quiet
kill_if_pidfile tmp/pids/server.pid
kill_if_pidfile tmp/pids/delayed-job.pid
govuk_setenv asset-manager bundle exec rake db:purge
govuk_setenv_daemon asset-manager tmp/pids/server.pid "bundle exec rails s -p 3037 -d"
govuk_setenv_daemon_background asset-manager tmp/pids/delayed-job.pid "bundle exec rake jobs:work &> log/delayed-job.log"
cd ..

clone_or_update email-alert-api git@github.com:alphagov/email-alert-api.git ${EMAIL_ALERT_API_BRANCH:-"master"}
cd email-alert-api
bundle install --quiet
kill_if_pidfile tmp/pids/server.pid
kill_if_pidfile tmp/pids/sidekiq.pid
govuk_setenv email-alert-api bundle exec rake db:setup
govuk_setenv_daemon email-alert-api tmp/pids/sidekiq.pid "bundle exec sidekiq -C ./config/sidekiq.yml -P tmp/pids/sidekiq.pid -d"
govuk_setenv_daemon email-alert-api tmp/pids/server.pid "bundle exec rails s -p 3088 -d"
cd ..

clone_or_update specialist-publisher git@github.com:alphagov/specialist-publisher.git ${SPECIALIST_PUBLISHER_BRANCH:-"master"}
cd specialist-publisher
bundle install --quiet
kill_if_pidfile tmp/pids/server.pid
kill_if_pidfile tmp/pids/sidekiq.pid
govuk_setenv specialist-publisher bundle exec rake db:seed
govuk_setenv specialist-publisher bundle exec rake publishing_api:publish_finders
govuk_setenv_daemon specialist-publisher tmp/pids/sidekiq.pid "bundle exec sidekiq -C ./config/sidekiq.yml -P tmp/pids/sidekiq.pid -d"
# Theres a path bug in specialist publisher so we can't run it in the background
govuk_setenv specialist-publisher start-stop-daemon --start --startas "/bin/sh" --pid tmp/pids/server.pid --chdir . --background -- -c "bundle exec rails s -p 3064"
cd ..

clone_or_update static git@github.com:alphagov/static.git ${STATIC_BRANCH:-"master"}
cd static
bundle install --quiet
kill_if_pidfile tmp/pids/server.pid
govuk_setenv_daemon static tmp/pids/server.pid "bundle exec rails s -p 3013 -d"
cd ..

clone_or_update specialist-frontend git@github.com:alphagov/specialist-frontend.git ${SPECIALIST_FRONTEND_BRANCH:-"master"}
cd specialist-frontend
bundle install --quiet
kill_if_pidfile tmp/pids/server.pid
govuk_setenv_daemon specialist-frontend tmp/pids/server.pid "bundle exec rails s -p 3065 -d"
cd ..

clone_or_update finder-frontend git@github.com:alphagov/finder-frontend.git ${FINDER_FRONTEND_MASTER:-"master"}
cd finder-frontend
bundle install --quiet
kill_if_pidfile tmp/pids/server.pid
govuk_setenv_daemon finder-frontend tmp/pids/server.pid "bundle exec rails s -p 3062 -d"
cd ..

clone_or_update router git@github.com:alphagov/router.git ${ROUTER_BRANCH:-"master"}
gopath_dir=$(basename $GOPATH)
org_path="$gopath_dir/src/github.com/alphagov"
if [ ! -d "$org_path/router" ]; then
  mkdir -p $org_path
  mv router $org_path
  ln -s "$org_path/router" router
fi
cd router
govuk_setenv router go get github.com/tools/godep
kill_if_pidfile /tmp/router.pid
govuk_setenv_daemon_background router /tmp/router.pid "make run &> /var/log/router/e2e.log"
cd ..

