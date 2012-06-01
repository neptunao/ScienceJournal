require "rspec"
require 'spec_helper'
include RSpec::Rails::Matchers::RoutingMatchers
include ActionDispatch::Assertions::RoutingAssertions

describe "Routing" do
  it "to root page should be registration" do
    { get:'/' }.should route_to controller: 'pages', action: 'home'
  end
end