UiChanged::Engine.routes.draw do

  root :to => "screenshots#index"

  match '/screenshots/crawl_status' => 'screenshots#crawl_status', :as => :screenshot_crawl_status

  match '/screenshots/diffs' => 'screenshots#diffs', :as => :screenshot_diffs
  match '/screenshots/compares' => 'screenshots#compares', :as => :screenshot_compares
  match '/screenshots/controls' => 'screenshots#controls', :as => :screenshot_controls
  match '/screenshots/tests' => 'screenshots#tests', :as => :screenshot_tests
  match '/screenshots/diff' => 'screenshots#diff', :as => :screenshot_diff

  match '/screenshots/remove_diff_and_test' => 'screenshots#remove_diff_and_test', :as => :remove_diff_and_test, :via => :delete
  match '/screenshots/remove_all_diffs_and_tests' => 'screenshots#remove_all_diffs_and_tests', :as => :remove_all_diffs_and_tests, :via => :delete
  match '/screenshots/set_test_as_control' => 'screenshots#set_test_as_control', :as => :screenshot_set_test_as_control, :via => :post
  match '/screenshots/set_all_tests_as_control' => 'screenshots#set_all_tests_as_control', :as => :screenshot_set_all_tests_as_control, :via => :post
  match '/screenshots/destroy_all_controls' => 'screenshots#destroy_all_controls', :as => :screenshot_destroy_all_controls, :via => :delete
  match '/screenshots/destroy_all_tests' => 'screenshots#destroy_all_tests', :as => :screenshot_destroy_all_tests, :via => :delete
  match '/screenshots/destroy_all_compares' => 'screenshots#destroy_all_compares', :as => :screenshot_destroy_all_compares, :via => :delete

  match '/screenshots/start_all' => 'screenshots#start_all', :as => :screenshot_start_all, :via => :post
  match '/screenshots/start_control' => 'screenshots#start_control', :as => :screenshot_start_control, :via => :post
  match '/screenshots/start_test' => 'screenshots#start_test', :as => :screenshot_start_test, :via => :post
  match '/screenshots/start_control_test' => 'screenshots#start_control_test', :as => :screenshot_start_control_test, :via => :post
  match '/screenshots/start_control_compare' => 'screenshots#start_control_compare', :as => :screenshot_start_control_compare, :via => :post
  match '/screenshots/start_test_compare' => 'screenshots#start_test_compare', :as => :screenshot_start_test_compare, :via => :post
  match '/screenshots/start_compare' => 'screenshots#start_compare', :as => :screenshot_start_compare, :via => :post
  match '/screenshots/cancel' => 'screenshots#cancel', :as => :screenshot_cancel, :via => :post

  match '/screenshot_ignore_urls/add' => 'screenshot_ignore_urls#add', :via => :post
  match '/screenshot_ignore_urls/add_all_controls' => 'screenshot_ignore_urls#add_all_controls', :as => :screenshot_ignore_url_add_all_controls, :via => :post
  match '/screenshot_ignore_urls/add_all_tests' => 'screenshot_ignore_urls#add_all_tests', :as => :screenshot_ignore_url_add_all_tests, :via => :post
  match '/screenshot_ignore_urls/add_all_compares' => 'screenshot_ignore_urls#add_all_compares', :as => :screenshot_ignore_url_add_all_compares, :via => :post
  match '/screenshot_ignore_urls/add_all_diffs' => 'screenshot_ignore_urls#add_all_diffs', :as => :screenshot_ignore_url_add_all_diffs, :via => :post
  match '/screenshot_ignore_urls/destroy_all' => 'screenshot_ignore_urls#destroy_all', :as => :screenshot_ignore_url_destroy_all, :via => :delete

  resources :screenshot_ignore_urls, :only => [:index, :destroy]
  resources :screenshots, :only => [:index, :destroy]

end
