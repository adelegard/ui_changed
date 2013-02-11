module UiChanged
  class ScreenshotIgnoreUrl < ActiveRecord::Base
    attr_accessible :url

    validates :url, :presence => true, :format => URI::regexp(%w(http https))

    self.per_page = 15

    class << self
      def search(search)
        UiChanged::ScreenshotIgnoreUrl.where('ui_changed_screenshot_ignore_urls.url LIKE ?', "%#{search}%")
      end
    end
  end
end
