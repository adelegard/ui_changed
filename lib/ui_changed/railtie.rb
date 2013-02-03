require 'ui_changed'
require 'rails'

module UiChanged
  class Railtie < Rails::Railtie
    railtie_name :ui_changed

    rake_tasks do
      load "tasks/ui_changed_tasks.rake"
    end
  end
end