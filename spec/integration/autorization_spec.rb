require 'spec_helper'
include Devise::TestHelpers

describe 'Autorization' do
  before :each do
    load "#{Rails.root}/db/seeds.rb"
  end
  def login
    @user = FactoryGirl.create(:user)
    visit '/login'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'
  end
  it 'change sign in link to sign out' do
    login
    response.should_not have_selector 'a', href: '/login', content: 'Sign in'
    response.should_not have_selector 'a', href: '/register', content: 'Sign up'
    response.should have_selector 'a', href: '/logout', content: 'Sign out'
  end
  it 'change sign out link to sign in' do
    login
    visit '/logout'
    response.should_not have_selector 'a', href: '/logout', content: 'Sign out'
    response.should have_selector 'a', href: '/login', content: 'Sign in'
    response.should have_selector 'a', href: '/register', content: 'Sign up'
  end
  it 'edit profile page contains name field' do
    login
    visit edit_user_registration_path(@user)
    response.should have_selector 'input', name: 'user[name]'
  end
  it 'register page contains name field' do
    visit new_user_registration_path
    response.should have_selector 'input', name: 'user[name]'
  end
  it 'register page contains type field' do
    visit new_user_registration_path
    assert_tag tag: 'select', attributes: { name: 'user[role_ids]' }, children: { count: 2 }
    response.should have_selector 'select option', value: Role.author_role.id.to_s
    response.should have_selector 'select option', value: Role.censor_role.id.to_s
  end
end