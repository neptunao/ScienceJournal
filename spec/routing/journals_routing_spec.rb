describe "Journals routing" do
  it 'routes to index' do
    { get: '/journals' }.should route_to controller: 'journals', action: 'index'
  end
  it 'routes to show' do
    { get: '/journals/1/'}.should route_to controller: 'journals', action: 'show', id: '1'
  end
  it 'routes to new' do
    { get: '/journals/new' }.should route_to controller: 'journals', action: 'new'
  end
  it 'no routes to edit' do
    { get: '/journals/1/edit' }.should_not route_to controller: 'journals', action: 'edit', id: '1'
  end
  it 'routes to create' do
    { post: '/journals' }.should route_to controller: 'journals', action: 'create'
  end
  it 'no routes to update' do
    { put: '/journals/1' }.should_not route_to controller: 'journals', action: 'update', id: '1'
  end
  it 'no routes to destroy' do
    { delete: '/journals/1' }.should_not route_to controller: 'journals', action: 'destroy', id: '1'
  end
  it 'routes to nested article' do
    { get: '/journals/1/articles/1' }.should route_to controller: 'articles', action: 'show', journal_id: '1', id: '1'
  end
end