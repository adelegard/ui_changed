UiChanged::Engine.routes.draw do

  resources :screenshot_ignore_urls
  resources :screenshots

  match '/screenshot/crawl_status' => 'screenshot#crawl_status', :as => :screenshot_crawl_status

  match '/screenshot/diffs' => 'screenshot#diffs', :as => :screenshot_diffs
  match '/screenshot/compares' => 'screenshot#compares', :as => :screenshot_compares
  match '/screenshot/controls' => 'screenshot#controls', :as => :screenshot_controls
  match '/screenshot/tests' => 'screenshot#tests', :as => :screenshot_tests
  match '/screenshot/ignored' => 'screenshot#ignored', :as => :screenshot_ignored
  match '/screenshot/diff' => 'screenshot#diff', :as => :screenshot_diff

  match '/screenshot/remove_diff_and_test' => 'screenshot#remove_diff_and_test', :as => :remove_diff_and_test, :via => :delete
  match '/screenshot/remove_all_diffs_and_tests' => 'screenshot#remove_all_diffs_and_tests', :as => :remove_all_diffs_and_tests, :via => :delete
  match '/screenshot/set_test_as_control' => 'screenshot#set_test_as_control', :as => :screenshot_set_test_as_control, :via => :post
  match '/screenshot/set_all_tests_as_control' => 'screenshot#set_all_tests_as_control', :as => :screenshot_set_all_tests_as_control, :via => :post
  match '/screenshot/destroy_all_controls' => 'screenshot#destroy_all_controls', :as => :screenshot_destroy_all_controls, :via => :delete
  match '/screenshot/destroy_all_tests' => 'screenshot#destroy_all_tests', :as => :screenshot_destroy_all_tests, :via => :delete
  match '/screenshot/destroy_all_compares' => 'screenshot#destroy_all_compares', :as => :screenshot_destroy_all_compares, :via => :delete

  match '/screenshot/start_all' => 'screenshot#start_all', :as => :screenshot_start_all, :via => :post
  match '/screenshot/start_control' => 'screenshot#start_control', :as => :screenshot_start_control, :via => :post
  match '/screenshot/start_test' => 'screenshot#start_test', :as => :screenshot_start_test, :via => :post
  match '/screenshot/start_control_test' => 'screenshot#start_control_test', :as => :screenshot_start_control_test, :via => :post
  match '/screenshot/start_control_compare' => 'screenshot#start_control_compare', :as => :screenshot_start_control_compare, :via => :post
  match '/screenshot/start_test_compare' => 'screenshot#start_test_compare', :as => :screenshot_start_test_compare, :via => :post
  match '/screenshot/start_compare' => 'screenshot#start_compare', :as => :screenshot_start_compare, :via => :post
  match '/screenshot/cancel' => 'screenshot#cancel', :as => :screenshot_cancel, :via => :post

  match '/screenshot_ignore_url/add' => 'screenshot_ignore_url#add', :via => :post
  match '/screenshot_ignore_url/add_all_controls' => 'screenshot_ignore_url#add_all_controls', :as => :screenshot_ignore_url_add_all_controls, :via => :post
  match '/screenshot_ignore_url/add_all_tests' => 'screenshot_ignore_url#add_all_tests', :as => :screenshot_ignore_url_add_all_tests, :via => :post
  match '/screenshot_ignore_url/add_all_compares' => 'screenshot_ignore_url#add_all_compares', :as => :screenshot_ignore_url_add_all_compares, :via => :post
  match '/screenshot_ignore_url/add_all_diffs' => 'screenshot_ignore_url#add_all_diffs', :as => :screenshot_ignore_url_add_all_diffs, :via => :post
  match '/screenshot_ignore_url/destroy_all' => 'screenshot_ignore_url#destroy_all', :as => :screenshot_ignore_url_destroy_all, :via => :delete

end
