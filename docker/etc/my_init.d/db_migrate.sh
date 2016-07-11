#!/bin/sh

if [ -n "$DB_MIGRATE" ]; then
  RAILS_ENV=production bundle exec rake db:migrate
fi
