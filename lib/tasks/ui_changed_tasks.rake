# desc "Explaining what the task does"
# task :ui_changed do
#   # Task goes here
# end
require 'ui_changed'

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

task :start_selenium_server => :environment do
  `java -jar #{Rails.root}/lib/tasks/selenium-server-standalone-2.28.0.jar`
end

task :start_resque => :environment do
  `QUEUE=* rake environment resque:work`
end