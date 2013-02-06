require 'test_helper'

module UiChanged
  class ScreenshotIgnoreUrlsControllerTest < ActionController::TestCase
=begin
    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:ignored_urls)
    end

    test "should create screenshot_ignore_url" do
      assert_difference('ScreenshotIgnoreUrl.count') do
        post :add, screenshot_ignore_url: { url: "http://testingtest" }
      end
  
      assert_redirected_to screenshot_ignore_url_path(assigns(:screenshot_ignore_url))
    end
  
    test "should destroy screenshot_ignore_url" do
      assert_difference('ScreenshotIgnoreUrl.count', -1) do
        delete :destroy, id: @screenshot_ignore_url
      end
  
      assert_redirected_to screenshot_ignore_urls_path
    end
=end
  end
end
