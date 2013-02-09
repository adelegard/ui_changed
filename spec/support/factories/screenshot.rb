FactoryGirl.define do
  factory :screenshot, class: UiChanged::Screenshot do
    url "http://www.testblah123.com"
    is_control true
    is_test false
    is_compare false
    diff_found false
    control_id nil
    test_id nil
    image_file_name "image1"
    image_file_size 501234
    image_content_type "png"
  end
end
