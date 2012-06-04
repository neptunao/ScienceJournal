require 'spec_helper'
include RSpec::Rails::Matchers::RoutingMatchers
include ActionDispatch::Assertions::RoutingAssertions

describe "Authors routing" do
  it 'no routes to index' do
    { get: '/authors' }.should_not route_to controller: 'authors', action: 'index'
  end
  it 'routes to show' do
    { get: '/authors/1/'}.should route_to controller: 'authors', action: 'show', id: '1'
  end
  it 'routes to new' do
    { get: '/authors/new' }.should route_to controller: 'authors', action: 'new'
  end
  it 'routes to edit' do
    { get: '/authors/1/edit' }.should route_to controller: 'authors', action: 'edit', id: '1'
  end
  it 'routes to create' do
    { post: '/authors' }.should route_to controller: 'authors', action: 'create'
  end
  it 'routes to update' do
    { put: '/authors/1' }.should route_to controller: 'authors', action: 'update', id: '1'
  end
  it 'no routes to destroy' do
    { delete: '/authors/1' }.should_not route_to controller: 'authors', action: 'destroy', id: '1'
  end
end