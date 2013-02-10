module UiChanged
  class ConfigHelper
    MTC_CONFIG.each do |config|
      # set the path
      if Rails.env.test? && config[0].end_with?("_path")
        define_singleton_method config[0], lambda { "#{Rails.root}/#{config[1]}" }
      else
        define_singleton_method config[0], lambda { config[1] }
      end
    end
  end
end