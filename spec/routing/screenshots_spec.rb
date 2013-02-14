require 'spec_helper'

require 'debugger'

describe "routing to screenshots" do

  it "loads home page with content" do
    visit "/ui_changed/screenshots"
    assert page.has_content?('Start All')
  end

  it "loads crawl_status with content" do
    visit "/ui_changed/screenshots/crawl_status"
    assert find('body').has_content?('[{"screenshots":')
  end

  it "loads diffs with content" do
    visit "/ui_changed/screenshots/diffs"
    assert find('h1').has_content?('Diff Screenshots')
  end

  it "loads controls with content" do
    visit "/ui_changed/screenshots/controls"
    assert find('h1').has_content?("Control Screenshots")
  end

  it "loads tests with content" do
    visit "/ui_changed/screenshots/tests"
    assert find('h1').has_content?("Test Screenshots")
  end

  it "loads compares with content" do
    visit "/ui_changed/screenshots/compares"
    assert find('h1').has_content?("Compare Screenshots")
  end

  it "loads ignores with content" do
    visit "/ui_changed/screenshot_ignore_urls"
    assert find('h1').has_content?("Ignored Urls")
  end  

#  before(:each) { @routes = UiChanged::Engine.routes }
# none of these tests work b/c of "No route matches" erros - annoying

=begin

  it "routes index to screenshots#index" do
    get :index
    page.driver.status_code.should eql 200
  end

  it "routes /index to screenshots#index" do
    expect(:get => "/screenshots").to route_to(
      :controller => "ui_changed/screenshots",
      :action => "index"
    )
  end

  it "routes /screenshots/diffs to screenshots#diffs" do
    expect(:get => "/screenshots/diffs").to route_to(
      :controller => "ui_changed/screenshot",
      :action => "diffs"
    )
  end

  it "routes /screenshots/controls to screenshots#controls" do
    expect(:get => "/screenshots/controls").to route_to(
      :controller => "ui_changed/screenshots",
      :action => "controls"
    )
  end

  it "routes /screenshots/tests to screenshots#tests" do
    expect(:get => "/screenshots/tests").to route_to(
      :controller => "ui_changed/screenshots",
      :action => "tests"
    )
  end

  it "routes /screenshots/compares to screenshots#compares" do
    expect(:get => "/screenshots/compares").to route_to(
      :controller => "ui_changed/screenshots",
      :action => "compares"
    )
  end
=end
end