require 'spec_helper'

describe "views for screenshots" do

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
end
