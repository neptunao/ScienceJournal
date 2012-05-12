require 'spec_helper'
include Devise::TestHelpers

describe 'Security permissions' do
  before :all do
    load "#{Rails.root}/db/seeds.rb"
    @author_user = FactoryGirl.create(:user)
    @censor_user = FactoryGirl.create(:censor_user)
    @users = [@author_user, @censor_user]
    @admin_user = FactoryGirl.create(:admin_user)
  end
  after :all do
    User.delete_all
  end
  def login(user)
    visit '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end
  it 'redirect guest to root when he put update_without_password request' do
    visit root_path
    put update_without_password_path, approved: []
    response.should redirect_to new_user_session_path
  end
  it 'redirect non-admin users to root when they put update_without_password request' do
    @users.each do |user|
      login user
      put update_without_password_path, approved: []
      response.should redirect_to root_path
      visit logout_path
    end
  end
end
