require 'spec_helper'
require 'debugger'

describe "screenshot functionality actions" do

  before(:each) {
    @screenshot1 = FactoryGirl.create(:screenshot, :image_file_name => "image_1", :image_content_type => "png")
    @screenshot2 = FactoryGirl.create(:screenshot, :image_file_name => "image_2", :image_content_type => "png")
    @screenshot3 = FactoryGirl.create(:screenshot, :image_file_name => "image_3", :image_content_type => "png")
    @screenshot4 = FactoryGirl.create(:screenshot, :image_file_name => "image_4", :image_content_type => "png")
    @screenshot5 = FactoryGirl.create(:screenshot, :image_file_name => "image_5", :image_content_type => "png")
  }

  # url

  it "should do something sweet 1" do
  end

  it "should do something sweet 2" do
  end

end