require 'spec_helper'

describe 'articles/new' do
  before :all do
    @files = []
    4.times { |i| @files << FactoryGirl.create(:data_file) }
  end

  before(:each) do
    assign(:article, stub_model(Article, title: "Test", data_files: @files ).as_new_record)
    render
  end

  after :all do
    DataFile.destroy_all
  end

  it 'render input forms' do
    rendered.should have_selector 'form', action: articles_path, method: 'post'
    rendered.should have_selector 'input', name: 'article[title]'
    rendered.should have_selector 'input', name: 'article[article]'
    rendered.should have_selector 'input', name: 'article[resume_rus]'
    rendered.should have_selector 'input', name: 'article[resume_eng]'
    rendered.should have_selector 'input', name: 'article[cover_note]'
    rendered.should have_selector 'input', name: 'commit', type: 'submit'
  end

  it 'should render fields for coauthors' do
    rendered.should have_selector 'input', name: 'article[authors_attributes][new_authors][first_name]'
    rendered.should have_selector 'input', name: 'article[authors_attributes][new_authors][middle_name]'
    rendered.should have_selector 'input', name: 'article[authors_attributes][new_authors][last_name]'
    rendered.should have_selector 'a', class: 'add_nested_fields'
    rendered.should have_selector 'input', name: 'article[authors_attributes][new_authors][_destroy]'
  end

  it 'should render review' do
    rendered.should have_selector 'input', name: 'has_review'
    rendered.should have_selector 'input', name: 'article[review]'
    rendered.should have_selector 'input', name: 'article[censor][degree]'
    rendered.should have_selector 'input', name: 'article[censor][post]'
  end

  it 'render partials' do
    rendered.should render_template('shared/_errors_explanation')
    rendered.should render_template('shared/_person', count: 2)
  end
end