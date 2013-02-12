require 'spec_helper'
require 'debugger'

describe "screenshot actions" do
  # url

  it "should not allow urls that don't start with http or https" do
    screenshot = build(:screenshot, :url => "badurl://www.google.com")
    screenshot.should_not be_valid
    screenshot.should have(1).error_on(:url)
  end

  it "should allow urls that start with http" do
    screenshot = build(:screenshot, :url => "http://www.google.com")
    screenshot.should be_valid
  end

  it "should allow urls that start with https" do
    screenshot = build(:screenshot, :url => "https://www.google.com")
    screenshot.should be_valid
  end

  # types

  it "should not allow all three types" do
    build(:screenshot,
      :is_control => true,
      :is_test => true,
      :is_compare => true).should_not be_valid
  end

  it "should not allow zero types" do
    build(:screenshot,
      :is_control => false,
      :is_test => false,
      :is_compare => false).should_not be_valid
  end

  it "should only have one type - control" do
    build(:screenshot,
      :is_control => true,
      :is_test => false,
      :is_compare => false).should be_valid
  end

  it "should only have one type - test" do
    build(:screenshot,
      :is_control => false,
      :is_test => true,
      :is_compare => false).should be_valid
  end

  it "should only have one type - compare" do
    # we also need to add in the control/test ids for it to validate
    build(:screenshot,
      :is_control => false,
      :is_test => false,
      :is_compare => true,
      :control_id => 1,
      :test_id => 2).should be_valid
  end

  it "should not validate if is control and diff found" do
    # we also need to add in the control/test ids for it to validate
    build(:screenshot, 
      :is_control => true, 
      :is_test => false, 
      :is_compare => false, 
      :diff_found => true,
      :control_id => 1,
      :test_id => 2).should_not be_valid
  end

  it "should not validate if is test and diff found" do
    build(:screenshot, 
      :is_control => false, 
      :is_test => true, 
      :is_compare => false, 
      :diff_found => true,
      :control_id => 1,
      :test_id => 2).should_not be_valid
  end

  it "should validate if is compare and diff found" do
    build(:screenshot, 
      :is_control => false, 
      :is_test => false, 
      :is_compare => true, 
      :diff_found => true,
      :control_id => 1,
      :test_id => 2).should be_valid
  end

  # control_id / test_id

  it "should not validate if is compare and control_id and test_id is nil" do
    build(:screenshot, 
      :is_control => false, 
      :is_test => false, 
      :is_compare => true).should_not be_valid
  end

  it "should not validate if is compare and test_id is nil" do
    build(:screenshot, 
      :is_control => false, 
      :is_test => false, 
      :is_compare => true,
      :control_id => 1).should_not be_valid
  end

  it "should not validate if is compare and control_id is nil" do
    screenshot = build(:screenshot, 
      :is_control => false, 
      :is_test => false, 
      :is_compare => true,
      :test_id => 1).should_not be_valid
  end

  it "should validate if is compare and control_id and test_id are populated" do
    screenshot = build(:screenshot, 
      :is_control => false, 
      :is_test => false, 
      :is_compare => true,
      :control_id => 1,
      :test_id => 2).should be_valid
  end

  # image_content_type

  it "should not allow image_content_type of doc" do
    screenshot = build(:screenshot, :image_content_type => "doc")
    screenshot.should_not be_valid
    screenshot.should have(1).error_on(:image_content_type)
  end

  it "should allow image_content_type of png" do
    screenshot = build(:screenshot, :image_content_type => "png")
    screenshot.should be_valid
  end

end