require 'spec_helper'
require 'debugger'

describe "screenshot functionality actions" do

  before(:each) {
    # controls
    (1..5).each do |i|
      create_screenshot({:id => i, :is_control => true, :is_test => false})
    end
    # tests
    (6..10).each do |i|
      create_screenshot({:id => i, :is_control => false, :is_test => true})
    end

    @testing_control_path = "#{UiChanged::Engine.root}/spec/test_screenshots/control/*"
    @testing_test_path = "#{UiChanged::Engine.root}/spec/test_screenshots/test/*"
    @testing_path_map = {"control" => @testing_control_path, "test" => @testing_test_path}

    @dummy_control_path = "#{UiChanged::ConfigHelper.control_path}"
    @dummy_test_path = "#{UiChanged::ConfigHelper.test_path}"
    @dummy_compare_path = "#{UiChanged::ConfigHelper.compare_path}"

    # clear out our dummy app screenshot directories
    UiChanged::WorkerBase.remove_folder_contents_or_create(@dummy_control_path)
    UiChanged::WorkerBase.remove_folder_contents_or_create(@dummy_test_path)
    UiChanged::WorkerBase.remove_folder_contents_or_create(@dummy_compare_path)

    # copy our test screenshots into the dummy directories
    copy_testing_screenshots_into("control", @dummy_control_path)
    copy_testing_screenshots_into("test", @dummy_test_path)
  }

  after(:each) {
    # clear out our dummy app screenshot directories
    UiChanged::WorkerBase.remove_folder_contents_or_create(@dummy_control_path)
    UiChanged::WorkerBase.remove_folder_contents_or_create(@dummy_test_path)
    UiChanged::WorkerBase.remove_folder_contents_or_create(@dummy_compare_path)
  }

=begin
  # this one isn't working - can't figure it out yet
  it "loads controls with content", :js => true do
    visit "/ui_changed/screenshots/controls"

    UiChanged::Screenshot.where(:is_control => true).count.should eq(5)

    all(".f_checkall_child").select.first.set(true)
    all(".f_remove").select.first.click

    UiChanged::Screenshot.where(:is_control => true).count.should eq(4)
  end
=end

  it "should have 5 db control entries" do
    UiChanged::Screenshot.where(:is_control => true).count.should eq(5)
  end

  it "should have 5 db test entries" do
    UiChanged::Screenshot.where(:is_test => true).count.should eq(5)
  end

  it "should set all tests as controls" do
    UiChanged::Screenshot.set_all_tests_as_controls
    UiChanged::Screenshot.find(:all).select{|s| s.is_control != true}.should be_empty

    # there are 2 per screenshot (i.e. image_1.png and image_1_small.png)
    num_files_in_directory(@dummy_control_path).should eq(10)
    num_files_in_directory(@dummy_test_path).should eq(0)
  end

  it "should set specific tests as controls" do
    UiChanged::Screenshot.set_tests_as_controls([6, 7])

    UiChanged::Screenshot.where("id IN (?)", [6, 7]).select{|s| s.is_control != true}.should be_empty
    UiChanged::Screenshot.where(:is_control => true).count.should eq(5)
    UiChanged::Screenshot.where(:is_test => true).count.should eq(3)

    # there are 2 per screenshot (i.e. image_1.png and image_1_small.png)
    num_files_in_directory(@dummy_control_path).should eq(10)
    num_files_in_directory(@dummy_test_path).should eq(6)
  end

  it "should delete all control images and records" do
    UiChanged::Screenshot.delete_all_controls
    UiChanged::Screenshot.where(:is_control => true).count.should eq(0)
    num_files_in_directory(@dummy_control_path).should eq(0)
  end

  it "should delete all test images and records" do
    UiChanged::Screenshot.delete_all_tests
    UiChanged::Screenshot.where(:is_test => true).count.should eq(0)
    num_files_in_directory(@dummy_test_path).should eq(0)
  end

  it "should delete specific ids" do
    # 2 tests & 2 controls
    UiChanged::Screenshot.destroy_entries_and_images([1, 2, 6, 7])
    UiChanged::Screenshot.where(:is_control => true).count.should eq(3)
    UiChanged::Screenshot.where(:is_test => true).count.should eq(3)
    num_files_in_directory(@dummy_control_path).should eq(6)
    num_files_in_directory(@dummy_test_path).should eq(6)
  end

end

def create_screenshot(params)
  FactoryGirl.create(:screenshot,
    :id => params[:id],
    :url => "http://www.ui_changed_test.com/test#{params[:id].modulo(5)}",
    :image_file_name => "image_#{params[:id]}",
    :is_control => params[:is_control],
    :is_test => params[:is_test])
end

def copy_testing_screenshots_into(type, dir)
  # copy our test screenshots into the dummy test directory
  test_screenshots_path = @testing_path_map[type]
  puts "copying files in #{@test_screenshots_path} to #{dir}"
  FileUtils.cp_r Dir.glob(test_screenshots_path), dir
end

def num_files_in_directory(dir)
  Dir[File.join(dir, '**', '*')].count { |file| File.file?(file) }
end

