require 'spec_helper'

describe AuthorsController do
  before :all do
    User.destroy_all
    Author.destroy_all
    @user = FactoryGirl.create(:user)
    @user.update_attribute(:person, FactoryGirl.create(:author))
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
    before :all do
      @user.update_attribute(:person, nil)
    end

    it 'assigns new author to @author' do
      get :new
      assigns(:author).should be_a_new(Author)
    end
  end

  describe '.create' do
    before :all do
      @user.update_attribute(:person, nil)
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

  describe '.show' do
    before :all do
      @user.update_attribute(:person, FactoryGirl.create(:author))
    end

    it 'redirect to login if not authenticated' do
      sign_out @user
      expected_id = @user.person.id
      get :show, id: expected_id
      response.should redirect_to new_user_session_path
    end

    it 'assigns user' do
      expected_id = @user.person.id
      get :show, id: expected_id
      assigns(:author).id.should be expected_id
    end
  end

  describe '.edit' do
    before :all do
      @user.update_attribute(:person, FactoryGirl.create(:author))
    end

    it 'redirect to login if not authenticated' do
      sign_out @user
      get :edit, id: @user.id
      response.should redirect_to new_user_session_path
    end

    it 'assigns user' do
      expected_id = @user.person.id
      get :edit, id: expected_id
      assigns(:author).id.should be expected_id
    end
  end

  describe '.update' do
    before :all do
      @user.update_attribute(:person, FactoryGirl.create(:author))
      @params = { author: { first_name: 'test_updated', middle_name: 'test_updated', last_name: 'test_updated' } }
    end

    it 'assigns user' do
      expected_id = @user.person.id
      put :update, { id: expected_id, author: { first_name: 'test_updated', middle_name: 'test_updated', last_name: 'test_updated' } }
      assigns(:author).id.should be expected_id
    end

    it 'updates and redirect to root if success' do
      put :update, { id: @user.person.id, author: { first_name: 'test_updated', middle_name: 'test_updated', last_name: 'test_updated' } }
      @user.reload
      @user.person.first_name.should eql 'test_updated'
      @user.person.middle_name.should eql 'test_updated'
      @user.person.last_name.should eql 'test_updated'
      response.should redirect_to root_path
    end

    it 'redirect to root page if errors' do
      put :update, { author: { } }
      response.should redirect_to root_path
    end
  end
end