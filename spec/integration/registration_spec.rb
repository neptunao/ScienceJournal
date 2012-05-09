require 'spec_helper'
include Devise::TestHelpers

describe "Registration" do
  before :each do
    load "#{Rails.root}/db/seeds.rb"
  end
  it 'should create new user' do
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
  end
end