describe "Categories routing" do
  it 'routes to index' do
    { get: '/categories' }.should route_to controller: 'categories', action: 'index'
  end

  it 'no routes to show' do
    { get: '/categories/1/'}.should_not route_to controller: 'categories', action: 'show', id: '1'
  end

  it 'routes to new' do
    { get: '/categories/new' }.should route_to controller: 'categories', action: 'new'
  end

  it 'routes to edit' do
    { get: '/categories/1/edit' }.should route_to controller: 'categories', action: 'edit', id: '1'
  end

  it 'routes to create' do
    { post: '/categories' }.should route_to controller: 'categories', action: 'create'
  end

  it 'routes to update' do
    { put: '/categories/1' }.should route_to controller: 'categories', action: 'update', id: '1'
  end

  it 'routes to destroy' do
    { delete: '/categories/1' }.should route_to controller: 'categories', action: 'destroy', id: '1'
  end

  it 'routes to rebuild' do
    { post: '/categories/rebuild' }.should route_to controller: 'categories', action: 'rebuild'
  end
end