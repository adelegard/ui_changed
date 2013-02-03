module UiChanged
  module ApplicationHelper
    def remove_all_path(request_fullpath)
      if request_fullpath.include?(screenshot_controls_path)
        screenshot_destroy_all_controls_path
      elsif request_fullpath.include?(screenshot_tests_path)
        screenshot_destroy_all_tests_path
      elsif request_fullpath.include?(screenshot_compares_path)
        screenshot_destroy_all_compares_path
      elsif request_fullpath.include?(screenshot_ignore_urls_path)
        screenshot_ignore_url_destroy_all_path
      end
    end
    def ignore_all_urls_path(request_fullpath)
      if request_fullpath.include?(screenshot_controls_path)
        screenshot_ignore_url_add_all_controls_path
      elsif request_fullpath.include?(screenshot_tests_path)
        screenshot_ignore_url_add_all_tests_path
      elsif request_fullpath.include?(screenshot_compares_path)
        screenshot_ignore_url_add_all_compares_path
      elsif request_fullpath.include?(screenshot_diffs_path)
        screenshot_ignore_url_add_all_diffs_path
      end
    end

    def show_remove_test_and_diff(request_fullpath)
      request_fullpath.include?(screenshot_diffs_path) || request_fullpath.include?(screenshot_diff_path)
    end
    def show_remove(request_fullpath)
      request_fullpath.include?(screenshot_controls_path) || 
      request_fullpath.include?(screenshot_tests_path) ||
      request_fullpath.include?(screenshot_compares_path) ||
      request_fullpath.include?(screenshot_ignore_urls_path)
    end
    def show_set_test_as_control(request_fullpath)
      request_fullpath.include?(screenshot_diffs_path) || request_fullpath.include?(screenshot_diff_path) || request_fullpath.include?(screenshot_tests_path)
    end
    def show_ignore_url(request_fullpath)
      request_fullpath.include?(screenshot_diffs_path) || 
      request_fullpath.include?(screenshot_controls_path) || 
      request_fullpath.include?(screenshot_tests_path) ||
      request_fullpath.include?(screenshot_compares_path)
    end
  end
end
