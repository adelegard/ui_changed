# desc "Explaining what the task does"
# task :ui_changed do
#   # Task goes here
# end
require 'ui_changed'
require 'resque/tasks'

# this doesn't seem to like being inside the ui_changed namespace
task "resque:setup" => :environment

namespace :ui_changed do

  # rake ss:crawl_for_control
  task :crawl_for_control => :environment do
    UiChanged::Screenshot.start_async_crawl_for_control
  end

  # rake ss:crawl_for_test
  task :crawl_for_test => :environment do
    UiChanged::Screenshot.start_async_crawl_for_test
  end

  # rake ss:crawl_for_control_and_test
  task :crawl_for_control_and_test => :environment do
    UiChanged::Screenshot.crawl_for_control_and_test
  end

  # rake ss:crawl_for_control_and_compare
  task :crawl_for_control_and_compare => :environment do
    UiChanged::Screenshot.start_async_crawl_for_control_and_compare
  end

  # rake ss:crawl_for_test_and_compare
  task :crawl_for_test_and_compare => :environment do
    UiChanged::Screenshot.start_async_crawl_for_test_and_compare
  end

  # rake ss:compare
  task :compare => :environment do
    UiChanged::Screenshot.start_async_compare
  end
end