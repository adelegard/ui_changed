source "http://rubygems.org"

# Declare your gem's dependencies in ui_changed.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem "bootstrap-sass"
gem 'will_paginate'
gem "haml-rails"
gem 'bootstrap-will_paginate'
gem 'anemone'
gem 'selenium-webdriver'
gem "jquery-rails"

gem 'resque'
gem 'resque_mailer'
gem 'resque-status'

group :active_record do
  platforms :jruby do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 1.2'
    gem 'jdbc-sqlite3', '~> 3.6'
  end

  platforms :ruby, :mswin, :mingw do
    case ENV['CI_DB_ADAPTER']
    when 'mysql2'
      gem 'mysql2', '2.8.1'
    when 'postgresql'
      gem 'pg', '~> 0.13'
    else
      gem 'sqlite3', '~> 1.3'
    end
  end
end

group :mongoid do
  gem 'mongoid', '~> 3.0'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'font-awesome-sass-rails'
end

group :test, :development do
  gem "factory_girl_rails"
  gem "rspec-rails"
  gem "capybara"
  gem 'debugger'
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'ruby-debug'
