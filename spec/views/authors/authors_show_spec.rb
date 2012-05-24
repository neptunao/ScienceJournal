require 'spec_helper'

describe 'authors/show' do
  before(:each) do
    @first_name = 'test_first_name'
    @middle_name = 'test_middle_name'
    @last_name = 'test_last_name'
    assign(:author, stub_model(Author, first_name: @first_name, middle_name: @middle_name, last_name: @last_name).as_new_record)
  end

  it 'render input forms' do
    render
    rendered.should render_template '_author_show'
    rendered.should have_selector 'p', content: @first_name
    rendered.should have_selector 'p', content: @middle_name
    rendered.should have_selector 'p', content: @last_name
  end

  it 'not render middle_name if it not exist' do
    assign(:author, stub_model(Author, first_name: @first_name, last_name: @last_name).as_new_record)
    render
    rendered.should_not have_selector 'b', content: 'Middle name'
  end
end