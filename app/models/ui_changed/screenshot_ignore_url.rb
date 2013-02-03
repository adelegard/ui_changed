module UiChanged
  class ScreenshotIgnoreUrl < ActiveRecord::Base
    attr_accessible :url

    self.per_page = 10

    class << self
      def search(search)
        ScreenshotIgnoreUrl.where('screenshot_ignore_urls.url LIKE ?', "%#{search}%")
      end

      def all_ignores_urls_as_reg_exp
        Regexp.new(ConfigHelper.skip_url_reg_exp)
      end
    end
  end
end
