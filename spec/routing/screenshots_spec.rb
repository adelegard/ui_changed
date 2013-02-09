require 'spec_helper'

require 'debugger'

describe "routing to screenshots" do
  before(:each) { @routes = UiChanged::Engine.routes }

=begin
  it "Routes the root to the screenshot controller's index action" do
    get(:index, {:use_route => :ui_changed}).should route_to(:controller => 'ui_changed/screenshots', :action => 'index')
    #{ :get => '/' }.should route_to(:controller => 'ui_changed/screenshots', :action => 'index')
  end

  it "routes /index to screenshots#index" do
    expect(:get => "/ui_changed/screenshots").to route_to(
      :controller => "screenshots",
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