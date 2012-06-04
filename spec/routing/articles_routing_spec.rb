require 'spec_helper'
include RSpec::Rails::Matchers::RoutingMatchers
include ActionDispatch::Assertions::RoutingAssertions

describe "Articles routing" do
  it 'routes to index' do
    { get: '/articles' }.should route_to controller: 'articles', action: 'index'
  end
  it 'routes to show' do
    { get: '/articles/1/'}.should route_to controller: 'articles', action: 'show', id: '1'
  end
  it 'routes to new' do
    { get: '/articles/new' }.should route_to controller: 'articles', action: 'new'
  end
  it 'no routes to edit' do
    { get: '/articles/1/edit' }.should_not route_to controller: 'articles', action: 'edit', id: '1'
  end
  it 'routes to create' do
    { post: '/articles' }.should route_to controller: 'articles', action: 'create'
  end
  it 'routes to update' do
    { put: '/articles/1' }.should route_to controller: 'articles', action: 'update', id: '1'
  end
  it 'no routes to destroy' do
    { delete: '/articles/1' }.should_not route_to controller: 'articles', action: 'destroy', id: '1'
  end
end