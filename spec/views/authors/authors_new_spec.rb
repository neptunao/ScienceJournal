require 'spec_helper'

describe 'authors/new' do
  before(:each) do
    assign(:author, stub_model(Author, first_name: "Test", last_name: 'Test').as_new_record)
  end

  it 'render input forms' do
    render
    rendered.should have_selector 'form', action: authors_path, method: 'post'
    rendered.should have_selector 'input', name: 'author[first_name]'
    rendered.should have_selector 'input', name: 'author[middle_name]'
    rendered.should have_selector 'input', name: 'author[last_name]'
    rendered.should have_selector 'input', name: 'commit', type: 'submit'
  end
  it 'render errors partial' do
    render
    rendered.should render_template('shared/_errors_explanation')
    rendered.should render_template('shared/_person')
  end
end