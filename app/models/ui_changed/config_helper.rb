module UiChanged
  class ConfigHelper
    MTC_CONFIG.each do |config|
      define_singleton_method config[0], lambda { config[1] }
    end
  end
end