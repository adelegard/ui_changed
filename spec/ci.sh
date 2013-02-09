#!/usr/bin/env sh
cd spec/dummy && bundle install --without debug && bundle exec rake ui_changed:prepare_ci_env db:create db:migrate && cd ../.. && bundle exec rake spec