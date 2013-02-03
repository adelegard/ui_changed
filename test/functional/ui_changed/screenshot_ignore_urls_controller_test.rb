require 'test_helper'

module UiChanged
  class ScreenshotIgnoreUrlsControllerTest < ActionController::TestCase
    setup do
      @screenshot_ignore_url = screenshot_ignore_urls(:one)
    end
  
    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:screenshot_ignore_urls)
    end
  
    test "should get new" do
      get :new
      assert_response :success
    end
  
    test "should create screenshot_ignore_url" do
      assert_difference('ScreenshotIgnoreUrl.count') do
        post :create, screenshot_ignore_url: { url: @screenshot_ignore_url.url }
      end
  
      assert_redirected_to screenshot_ignore_url_path(assigns(:screenshot_ignore_url))
    end
  
    test "should show screenshot_ignore_url" do
      get :show, id: @screenshot_ignore_url
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, id: @screenshot_ignore_url
      assert_response :success
    end
  
    test "should update screenshot_ignore_url" do
      put :update, id: @screenshot_ignore_url, screenshot_ignore_url: { url: @screenshot_ignore_url.url }
      assert_redirected_to screenshot_ignore_url_path(assigns(:screenshot_ignore_url))
    end
  
    test "should destroy screenshot_ignore_url" do
      assert_difference('ScreenshotIgnoreUrl.count', -1) do
        delete :destroy, id: @screenshot_ignore_url
      end
  
      assert_redirected_to screenshot_ignore_urls_path
    end
  end
end
