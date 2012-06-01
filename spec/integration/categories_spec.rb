require 'spec_helper'

describe 'Categories' do
  before :all do
    User.destroy_all
    @admin = FactoryGirl.create(:admin_user)
    @author = FactoryGirl.create(:user)
  end

  it 'render sortable tree if admin' do
    login @admin
    visit categories_path
    response.should have_selector 'b', class: 'controls'
  end

  it 'render simple tree if not admin' do
    login @author
    visit categories_path
    response.should_not have_selector 'b', class: 'controls'
  end

  it 'render simple tree if guest' do
    visit categories_path
    response.should_not have_selector 'b', class: 'controls'
  end

  it 'simple tree node is a link to journals with category' do
    c = FactoryGirl.create(:category)
    visit categories_path
    click_link c.title
    current_url.should eql journals_path(category_id: c.id)
  end

  it 'admin tree node is a link to journals with category' do
    c = FactoryGirl.create(:category)
    login @admin
    visit categories_path
    click_link c.title
    current_url.should eql journals_path(category_id: c.id)
  end

  it '/new create new category' do
    login @admin
    visit new_category_path
    fill_in 'category[title]', with: 'test'
    expect { click_button 'Create category' }.to change(Category, :count).by 1
  end

  it 'create with errors render new' do
    login @admin
    visit new_category_path
    click_button 'Create category'
    response.should render_template 'categories/new'
  end

  it '/edit update category' do
    login @admin
    c = FactoryGirl.create(:category)
    visit edit_category_path(c)
    fill_in 'category[title]', with: 'test123'
    click_button 'Update category'
    c.reload.title.should eql 'test123'
  end

  it 'update with errors render edit' do
    login @admin
    c = FactoryGirl.create(:category)
    visit edit_category_path(c)
    fill_in 'category[title]', with: ''
    click_button 'Update category'
    response.should render_template 'categories/edit'
  end

  it 'destroy node' do
    pending 'cant write test with JS confirm window'
  end

end