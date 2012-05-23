require 'spec_helper'
include Devise::TestHelpers

describe "Profile" do
  def login
    @user = FactoryGirl.create(:user)
    visit '/login'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'
  end

  it 'show action render correct views' do
    login
    visit show_profile_path
    response.should render_template 'layouts/profile'
    response.should render_template 'users/_user_show'
    pending 'authors_show'
  end
end