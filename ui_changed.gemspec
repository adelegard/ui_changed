$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ui_changed/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ui_changed"
  s.version     = UiChanged::VERSION
  s.date        = "2013-02-03"
  s.authors     = ["Alex Delegard"]
  s.email       = ["adelegard@gmail.com"]
  s.homepage    = "https://github.com/adelegard/ui_changed"
  s.summary     = "Rails plugin for crawling domains for detecting differences in the UI"
  s.description = "Rails plugin for crawling domains for detecting differences in the UI"

  s.files = Dir["{app,config,db,lib}/**/*"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.11"
  s.add_dependency "bootstrap-sass"
  s.add_dependency 'will_paginate'
  s.add_dependency 'bootstrap-will_paginate'
  s.add_dependency "haml-rails"
  s.add_dependency 'anemone'
  s.add_dependency 'selenium-webdriver'
  s.add_dependency "jquery-rails"
  s.add_dependency 'font-awesome-sass-rails'
  s.add_dependency 'resque'
  s.add_dependency 'resque_mailer'
  s.add_dependency 'resque-status'

  s.add_development_dependency 'sass-rails', '~> 3.2.3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency "capybara-webkit"
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency "mysql2"

end
