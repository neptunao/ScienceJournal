require "rspec"
require 'spec_helper'
include RSpec::Rails::Matchers::RoutingMatchers
include ActionDispatch::Assertions::RoutingAssertions

describe 'Users roting' do
  it 'to users page should be' do
    { get: '/users' }.should route_to controller: 'users', action: 'index'
  end

  it 'to show should be' do
    { get: '/users/show' }.should route_to controller: 'users', action: 'show'
    { get: '/users/show/1' }.should route_to controller: 'users', action: 'show', id: '1'
  end
end