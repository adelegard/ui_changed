require 'test_helper'

module UiChanged
  class ScreenshotsControllerTest < ActionController::TestCase
    setup do
      @screenshot = screenshots(:one)
    end
  
    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:screenshots)
    end
  
    test "should get new" do
      get :new
      assert_response :success
    end
  
    test "should create screenshot" do
      assert_difference('Screenshot.count') do
        post :create, screenshot: { control_id: @screenshot.control_id, diff_found: @screenshot.diff_found, image_content_type: @screenshot.image_content_type, image_file_name: @screenshot.image_file_name, image_file_size: @screenshot.image_file_size, is_compare: @screenshot.is_compare, is_control: @screenshot.is_control, is_test: @screenshot.is_test, test_id: @screenshot.test_id, url: @screenshot.url }
      end
  
      assert_redirected_to screenshot_path(assigns(:screenshot))
    end
  
    test "should show screenshot" do
      get :show, id: @screenshot
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, id: @screenshot
      assert_response :success
    end
  
    test "should update screenshot" do
      put :update, id: @screenshot, screenshot: { control_id: @screenshot.control_id, diff_found: @screenshot.diff_found, image_content_type: @screenshot.image_content_type, image_file_name: @screenshot.image_file_name, image_file_size: @screenshot.image_file_size, is_compare: @screenshot.is_compare, is_control: @screenshot.is_control, is_test: @screenshot.is_test, test_id: @screenshot.test_id, url: @screenshot.url }
      assert_redirected_to screenshot_path(assigns(:screenshot))
    end
  
    test "should destroy screenshot" do
      assert_difference('Screenshot.count', -1) do
        delete :destroy, id: @screenshot
      end
  
      assert_redirected_to screenshots_path
    end
  end
end
