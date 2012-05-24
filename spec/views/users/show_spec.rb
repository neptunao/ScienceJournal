require 'spec_helper'

describe 'users/show' do
  before(:each) do
    stub!(:current_user, name: 'test',)
    assign(:user, stub_model(User, name: "test_name", email: 'test@email.com').as_new_record)
  end

  it 'render input forms' do
    render
    rendered.should render_template '_user_show'
    rendered.should have_selector 'p', content: 'test_name'
    rendered.should have_selector 'p', content: 'test@email.com'
  end
end