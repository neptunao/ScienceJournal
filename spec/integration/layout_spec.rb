require 'spec_helper'

describe 'Layout' do
  def login
    @user = FactoryGirl.create(:user)
    visit '/login'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'
  end

  it 'render errors' do
    login
    visit new_author_path
    click_button 'Create Author'
    response.should have_selector 'div', class: 'alert alert-error'
    assigns(:author).errors.full_messages.each do |m|
      response.should have_selector 'li', content: m
    end
  end

  it 'of profile contains links' do
    login
    visit show_profile_path
    response.should render_template 'layouts/application'
    response.should have_selector 'a', href: show_profile_path
    response.should have_selector 'a', href: edit_personal_path
    response.should have_selector 'a', href: edit_user_registration_path(@user)
    response.should have_selector 'a', href: edit_user_password_path(@user)
  end

  it 'of Devise render profile layout' do
    pending 'not work because Devise'
  end
end