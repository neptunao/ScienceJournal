require "rspec"
require 'spec_helper'
include RSpec::Rails::Matchers::RoutingMatchers
include ActionDispatch::Assertions::RoutingAssertions

describe "Routing" do
  it "root page should be registration" do
    { get:'/' }.should route_to controller: 'devise/sessions', action: 'new'
  end
end