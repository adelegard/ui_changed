# desc "Explaining what the task does"
# task :ui_changed do
#   # Task goes here
# end
require 'resque/tasks'

# desc "Use this to initiate crawling. Pass in "true" to start control crawl and "false" for test
# rake ui_changed:crawl["true"]
task :crawl, [:is_control] => :environment do |t, args|
  is_control = args.is_control == "true" ? true : false

  Screenshot.start_async_crawl_by_is_control(is_control)
end

# rake ss_compare:begin
task :compare => :environment do
  Screenshot.start_async_compare
end