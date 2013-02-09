require 'spec_helper'
require 'debugger'

describe "screenshot ignore url actions" do

  before(:each) { @screenshot_ignore_url = FactoryGirl.build(:screenshot_ignore_url) }

  it "should not allow ignore urls that don't start with http or https" do
    @screenshot_ignore_url.url = "badurl://www.google.com"
    @screenshot_ignore_url.should_not be_valid
    @screenshot_ignore_url.should have(1).error_on(:url)
  end

  it "should allow ignore urls that start with http" do
    @screenshot_ignore_url.url = "http://www.google.com"
    @screenshot_ignore_url.should be_valid
  end

  it "should allow urls that start with https" do
    @screenshot_ignore_url.url = "https://www.google.com"
    @screenshot_ignore_url.should be_valid
  end

end