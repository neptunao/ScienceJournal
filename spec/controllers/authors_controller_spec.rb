require 'spec_helper'
include Devise::TestHelpers

describe AuthorsController do
  before :all do
    User.destroy_all
    @user = FactoryGirl.create(:user)
  end

  after :all do
    Author.destroy_all
    User.destroy_all
  end

  before :each do
    sign_in @user
  end

  after :each do
    sign_out @user
  end

  describe '.new' do
    it 'assigns new author to @author' do
      get :new
      assigns(:author).should be_a_new(Author)
    end
  end

  describe '.create' do
    before :all do
      @params = { author: { first_name: 'test', last_name: 'test' } }
    end

    it 'create new user' do
      expect { post :create, @params }.to change(Author, :count).by(1)
    end

    it 'assigns new author to @author' do
      post :create, @params
      assigns(:author).id.should be Author.last.id
    end

    it 'redirect to home page' do
      post :create, @params
      response.should redirect_to root_path
    end

    it 'redirect to new author page if errors' do
      post :create, { author: { } }
      response.should render_template 'new'
    end
  end
end