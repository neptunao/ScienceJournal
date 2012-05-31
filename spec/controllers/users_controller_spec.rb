require 'spec_helper'

describe UsersController do
  before :all do
    DataFile.destroy_all
    User.destroy_all
    load "#{Rails.root}/db/seeds.rb"
    @author_user = FactoryGirl.create(:user)
    @censor_user = FactoryGirl.create(:censor_user)
    @users = [@author_user, @censor_user]
    @admin_user = FactoryGirl.create(:admin_user)
  end

  after :all do
    User.delete_all
  end

  it 'redirect to root non admin user request index action' do
    @users.each do |user|
      sign_in user
      get 'index', approved: []
      response.should redirect_to root_path
      sign_out user
    end
  end

  it 'require authorization on index' do
    get :index
    response.should redirect_to new_user_session_path
  end

  it 'require authorization on show' do
    get :show
    response.should redirect_to new_user_session_path
  end

  it 'response on show is ok after authorization' do
    @users.each do |user|
      sign_in user
      get :show
      response.should be_success
      sign_out user
    end
  end

  it 'assign @user as current_user on show' do
    sign_in @author_user
    get :show
    assigns(:user).id.should be @author_user.id
    sign_out @author_user
  end

  it 'assign @user as user in params on show' do
    sign_in @author_user
    get :show, { id: "#{@censor_user.id}" }
    assigns(:user).id.should be @censor_user.id
    sign_out @author_user
  end

  it 'redirect to root when show params are incorrect' do
    sign_in @author_user
    get :show, { id: "-1" }
    response.should redirect_to root_path
    sign_out @author_user
  end
end