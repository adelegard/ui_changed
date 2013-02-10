#!/usr/bin/env sh
cd spec/dummy && bundle install --without debug && bundle exec rake ui_changed:prepare_ci_env db:test:prepare && cd ../.. && bundle exec rake spec