module UiChanged
  class ScreenshotControllerBase < ApplicationController
    before_filter :authenticate
    before_filter :screenshot_counts, only: [:index, :diffs, :compares, :controls, :tests, :ignored, :settings, :diff]

    def screenshot_counts
      @search = params[:search]
      @diff_count = Screenshot.not_in_ignored.where(:diff_found => true).count
      @control_count = Screenshot.not_in_ignored.where(:is_control => true).count
      @test_count = Screenshot.not_in_ignored.where(:is_test => true).count
      @compare_count = Screenshot.not_in_ignored.where(:is_compare => true).count
      @ignore_count = ScreenshotIgnoreUrl.count
    end

    protected

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == ConfigHelper.auth_username && password == ConfigHelper.auth_password
      end
    end
  end
end