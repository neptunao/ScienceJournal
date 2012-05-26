require 'spec_helper'
include Devise::TestHelpers

describe "Registration" do
  before :all do
    User.destroy_all
    load "#{Rails.root}/db/seeds.rb"
  end

  it 'should create new author' do
    visit new_user_registration_path
    fill_in 'Name', with: 'test_user'
    fill_in 'Email', with: 'test_user@example.com'
    fill_in 'Password', with: 'foobar'
    fill_in 'Password confirmation', with: 'foobar'
    select 'author', from: 'user[role_ids]'
    click_button 'Sign up'
    user = User.find_by_name('test_user')
    user.should_not be nil
    user.roles =~ [Role.author_role, Role.guest_role]
    user.should be_is_approved
  end

  it 'should create new censor' do
    visit new_user_registration_path
    fill_in 'Name', with: 'test_censor'
    fill_in 'Email', with: 'test_censor@example.com'
    fill_in 'Password', with: 'foobar'
    fill_in 'Password confirmation', with: 'foobar'
    select 'censor', from: 'user[role_ids]'
    click_button 'Sign up'
    user = User.find_by_name('test_censor')
    user.should_not be nil
    user.roles =~ [Role.censor_role, Role.guest_role]
    user.should_not be_is_approved
  end
end