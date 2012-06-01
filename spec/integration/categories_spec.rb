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
end