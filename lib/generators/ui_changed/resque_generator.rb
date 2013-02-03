module UiChanged
  module Generators
    class ResqueGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_resque
        copy_file "resque.rb", "config/initializers/resque.rb"
      end
    end
  end
end