require 'spec_helper'
include Devise::TestHelpers

describe "Profile" do
  def login
    @user = FactoryGirl.create(:user)
    @user.update_attribute(:person, Author.create(first_name: '1test1', last_name: '2test2'))
    visit '/login'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'
  end

  it 'not render author template when person nil' do
    login
    @user.update_attribute(:person, nil)
    visit show_profile_path
    response.should_not render_template 'authors/_author_show'
  end

  it 'show action render correct views' do
    login
    visit show_profile_path
    response.should render_template 'layouts/profile'
    response.should render_template 'users/_user_show'
    response.should render_template 'authors/_author_show'
  end
end