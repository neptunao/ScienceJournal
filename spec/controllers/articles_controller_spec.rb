require 'spec_helper'

describe ArticlesController do
  before :all do
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

  describe '.new' do
    it 'redirect to login if guest' do
      get :new
      response.should redirect_to new_user_session_path
    end

    it 'redirect to root if not author' do
      sign_in @censor_user
      get :new
      response.should redirect_to root_path
    end

    it 'assigns new article to @article' do
      sign_in @author_user
      get :new
      assigns(:article).should be_a_new(Article)
    end
  end
end
