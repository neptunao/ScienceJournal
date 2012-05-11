require 'spec_helper'
include Devise::TestHelpers

describe 'Admin' do
  before :all do
    User.delete_all
    load "#{Rails.root}/db/seeds.rb"
    @user1 = FactoryGirl.create(:censor_user)
    @user2 = FactoryGirl.create(:censor_user, name: @user1.name + '1', email: @user1.email + 'a')
    @user3 = FactoryGirl.create(:censor_user, name: @user1.name + '2', email: @user1.email + 'b')
    @users = [@user1, @user2, @user3]
  end
  before :each do
    admin = User.first
    visit '/login'
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Sign in'
  end
  after :all do
    User.delete_all
  end
  it 'cabinet page contains pending registrations link' do
    visit '/cabinet'
    response.should have_selector 'a', href: '/users?approved=false', content: 'Pending registrations'
  end
  it 'approved users page contains list of unapproved users' do
    visit '/users?approved=false'
    @users.each do |user|
      response.should have_selector 'a', href: edit_user_registration_path(user), content: user.name
      response.should have_selector 'input', name: "approved[#{user.id}]", type: 'checkbox'
      response.should have_selector 'input', type: 'submit'
    end
  end
  it 'approved user' do
    visit '/users?approved=false'
    check("approved[#{@user1.id}]")
    check("approved[#{@user2.id}]")
    check("approved[#{@user3.id}]")
    click_button 'Save'
    @users.each { |user| user.reload }
    @user1.should be_is_approved
    @user2.should be_is_approved
    @user3.should be_is_approved
  end
end