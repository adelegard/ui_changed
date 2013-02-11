source "http://rubygems.org"

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
  platforms :ruby, :mswin, :mingw do
    case ENV['CI_DB_ADAPTER']
    when 'mysql2'
      gem 'mysql2'
    when 'postgresql'
      gem 'pg', '~> 0.13'
    else
      gem 'sqlite3', '~> 1.3'
    end
  end
end

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
  gem "capybara-webkit"
  gem 'debugger'
  gem 'database_cleaner'
end
