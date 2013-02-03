$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ui_changed/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ui_changed"
  s.version     = UiChanged::VERSION
  s.authors     = ["Alex Delegard"]
  s.email       = ["adelegard@gmail.com"]
  s.homepage    = ""
  s.summary     = "Rails plugin for crawling domains for detecting differences in the UI"
  s.description = "Rails plugin for crawling domains for detecting differences in the UI"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.11"

  s.add_dependency "bootstrap-sass"
  s.add_dependency 'will_paginate'
  s.add_dependency "haml-rails"
  s.add_dependency 'bootstrap-will_paginate'
  s.add_dependency "rmagick", "~> 2.13.1"
  s.add_dependency 'anemone'
  s.add_dependency 'selenium-webdriver'

  s.add_dependency 'font-awesome-sass-rails'

  s.add_dependency 'resque'
  s.add_dependency 'resque_mailer'
  s.add_dependency 'resque-status'

  # s.add_dependency "jquery-rails"

  s.add_development_dependency "mysql2"
end
