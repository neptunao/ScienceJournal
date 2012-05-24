require 'spec_helper'
include Devise::TestHelpers

describe "Profile" do
  before :all do
    User.destroy_all
    Author.destroy_all
    @user = FactoryGirl.create(:user)
    @author = Author.create(first_name: 'first_name', last_name: 'last_name')
  end

  before :each do
    @user.update_attribute(:person, @author)
    @user.reload
    login
  end

  after :each do
    visit 'logout'
  end

  def login
    visit '/login'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'
  end

  it 'not render author template when person nil' do
    @user.update_attribute(:person, nil)
    visit show_profile_path
    response.should_not render_template 'authors/_author_show'
  end

  it 'show action render correct views' do
    visit show_profile_path
    response.should render_template 'layouts/profile'
    response.should render_template 'users/_user_show'
    response.should render_template 'authors/_author_show'
  end

  it 'edit_personal_info action render correct views' do
    visit edit_personal_path
    response.should render_template 'layouts/profile'
    response.should render_template 'shared/_person'
  end

  it 'edit_personal_info action is correct when user has no person' do
    @user.update_attribute(:person, nil)
    visit edit_personal_path
    response.should be_success
  end

  it 'change user.person on edit_personal_info action' do
    @user.update_attribute(:person, nil)
    visit edit_personal_path
    fill_in 'user[person][first_name]', with: '1'
    fill_in 'user[person][middle_name]', with: '2'
    fill_in 'user[person][last_name]', with: '3'
    click_button 'Update User'
    current_url.should eql show_profile_url
    @user.reload
    @user.person.should_not be_nil
    @user.person.first_name.should eql '1'
    @user.person.middle_name.should eql '2'
    @user.person.last_name.should eql '3'
  end

  it 'update user.person on edit_personal_info action' do
    visit edit_personal_path
    @user.update_attribute(:person, @author)
    old_id = @user.person.id
    fill_in 'user[person][first_name]', with: '1'
    fill_in 'user[person][middle_name]', with: '2'
    fill_in 'user[person][last_name]', with: '3'
    click_button 'Update User'
    current_url.should eql show_profile_url
    @user.reload
    @user.person.should_not be_nil
    @user.person.id.should be old_id
    @user.person.first_name.should eql '1'
    @user.person.middle_name.should eql '2'
    @user.person.last_name.should eql '3'
  end
end