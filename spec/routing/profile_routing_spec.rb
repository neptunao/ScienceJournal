require 'spec_helper'
include RSpec::Rails::Matchers::RoutingMatchers
include ActionDispatch::Assertions::RoutingAssertions

describe "Profile routing" do
  it 'routes to show' do
    { get: '/profile/show' }.should route_to controller: 'profile', action: 'show'
  end
  it 'routes to edit personal info' do
    { get: '/profile/edit_personal' }.should route_to controller: 'profile', action: 'edit_personal_info'
  end
end