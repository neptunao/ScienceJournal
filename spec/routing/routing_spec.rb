require "rspec"
require 'spec_helper'
include RSpec::Rails::Matchers::RoutingMatchers
include ActionDispatch::Assertions::RoutingAssertions

describe "Routing" do
  it "to root page should be registration" do
    { get:'/' }.should route_to controller: 'pages', action: 'home'
  end

  it 'to cabinet page should be in pages' do
    { get: '/cabinet' }.should route_to controller: 'pages', action: 'cabinet'
  end
end