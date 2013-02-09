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

  task :start_selenium_server => :environment do
    `java -jar #{Rails.root}/lib/tasks/selenium-server-standalone-2.28.0.jar`
  end

  desc "CI env for Travis"
  task :prepare_ci_env do
    ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'true'
    adapter = ENV["CI_DB_ADAPTER"] || "mysql2"
    database = ENV["CI_DB_DATABASE"] || "ci_rails_admin"

    configuration = {
      "test" => {
        "adapter" => adapter,
        "database" => database,
        "username" => ENV["CI_DB_USERNAME"],
        "password" => ENV["CI_DB_PASSWORD"],
        "host" => ENV["CI_DB_HOST"] || "localhost",
        "encoding" => ENV["CI_DB_ENCODING"] || "utf8",
        "pool" => (ENV["CI_DB_POOL"] || 5).to_int,
        "timeout" => (ENV["CI_DB_TIMEOUT"] || 5000).to_int
      }
    }

    filename = Rails.root.join("config/database.yml")

    File.open(filename, "w") do |f|
      f.write(configuration.to_yaml)
    end
  end
end