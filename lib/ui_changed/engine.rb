require "bootstrap-sass"
require 'will_paginate'
require "haml-rails"
require 'bootstrap-will_paginate'
require "rmagick"
require 'anemone'
require 'selenium-webdriver'

require 'font-awesome-sass-rails'

require 'resque'
require 'resque_mailer'
require 'resque-status'

module UiChanged
  class Engine < ::Rails::Engine
    isolate_namespace UiChanged
  end
end
