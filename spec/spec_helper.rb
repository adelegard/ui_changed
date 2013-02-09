# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl_rails'

#FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
FactoryGirl.definition_file_paths = [
  File.join(UiChanged::Engine.root, 'spec/support/factories')
]
FactoryGirl.find_definitions

Rails.backtrace_cleaner.remove_silencers!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
#Dir[UiChanged::Engine.root.join("spec/support/**/*.rb")].each {|f| require f}

#ENGINE_RAILS_ROOT = File.join( File.dirname(__FILE__), '../')
#Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|

  # Factory Girl settings
  config.include FactoryGirl::Syntax::Methods

  # adding these to get route tests working. found answer at:
  # http://stackoverflow.com/questions/11587463/all-routing-examples-fail-for-a-rails-3-2-engine-with-rspec-2-10
#  config.before(:each, type: :controller) { @routes = UiChanged::Engine.routes }
#  config.before(:each, type: :routing)    { @routes = UiChanged::Engine.routes }
#  config.before(:each, type: :models)     { @screenshot = FactoryGirl.create(:screenshot) }

  config.include UiChanged::Engine.routes.url_helpers

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::UiChanged::Engine.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end
