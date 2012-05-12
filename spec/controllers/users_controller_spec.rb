require 'spec_helper'
include Devise::TestHelpers

describe UsersController do
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
  it 'does not allow update_without_password to guest' do
    lambda { put 'update_without_password', approved: [] }.should raise_error CanCan::AccessDenied #TODO integration test
  end
  it 'throw exception when non admin user request update_without_password action' do
    @users.each do |user|
      sign_in user
      lambda { put 'update_without_password', approved: [] }.should raise_error CanCan::AccessDenied
      sign_out user
    end
  end
  it 'throw exception when non admin user request index action' do
    @users.each do |user|
      sign_in user
      lambda { get 'index', approved: [] }.should raise_error CanCan::AccessDenied
      sign_out user
    end
  end
end