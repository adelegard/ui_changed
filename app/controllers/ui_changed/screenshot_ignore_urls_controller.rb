require_dependency "ui_changed/application_controller"

module UiChanged
  class ScreenshotIgnoreUrlController < ScreenshotControllerBase

    def index
      params[:sort] ||= "url asc"
      @ignored_urls = ScreenshotIgnoreUrl.search(params[:search]).paginate(:page => params[:page],
                                                                           :per_page => params[:per_page],
                                                                           :order => params[:sort])
    end

    # these ignore methods should be in a new ignore controller
    def add
      ids = params[:id].split(",")
      ids.each do |id|
        ss = Screenshot.find(id)
        ss_ignore = ScreenshotIgnoreUrl.find_or_create_by_url(ss.url)
        ss_ignore.save
      end
      head :ok
    end

    def add_all_controls
      screenshots = Screenshot.not_in_ignored.where(:is_control => true)
      screenshots.each do |screenshot|
        ss_ignore = ScreenshotIgnoreUrl.find_or_create_by_url(screenshot.url)
        ss_ignore.save
      end
      head :ok
    end
    def add_all_tests
      screenshots = Screenshot.not_in_ignored.where(:is_test => true)
      screenshots.each do |screenshot|
        ss_ignore = ScreenshotIgnoreUrl.find_or_create_by_url(screenshot.url)
        ss_ignore.save
      end
      head :ok
    end
    def add_all_compares
      Screenshot.not_in_ignored.where(:is_compare => true).each do |screenshot|
        ss_ignore = ScreenshotIgnoreUrl.find_or_create_by_url(screenshot.url)
        ss_ignore.save
      end
      head :ok
    end

    def destroy
      ids = params[:id].split(",")
      ids.each do |id|
        ss_ignore = ScreenshotIgnoreUrl.find(id)
        ss_ignore.destroy
      end
      head :ok
    end
    def destroy_all
      ScreenshotIgnoreUrl.delete_all
      head :ok
    end

    protected

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == ConfigHelper.auth_username && password == ConfigHelper.auth_password
      end
    end

  end

end
