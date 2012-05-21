require 'spec_helper'
include Devise::TestHelpers

describe 'Devise views' do
  def login
    @user = FactoryGirl.create(:user)
    visit '/login'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'
  end

  it 'devise views render errors_explanation' do
    visit new_user_registration_path
    response.should render_template 'shared/_errors_explanation'

    login

    visit edit_user_registration_path(@user)
    response.should render_template 'shared/_errors_explanation'

    visit edit_user_password_path
    response.should render_template 'shared/_errors_explanation'

    visit logout_path

    visit new_user_password_path
    response.should render_template 'shared/_errors_explanation'
  end
end