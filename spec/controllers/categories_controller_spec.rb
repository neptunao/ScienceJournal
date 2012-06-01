require 'spec_helper'

describe CategoriesController do
  describe '.index' do
    it 'assign categories' do
      FactoryGirl.create(:category)
      FactoryGirl.create(:category)
      get :index
      assigns(:categories).should =~ Category.nested_set.all
    end
  end

  describe '.new' do
    it 'redirect to login if guest' do
      get :new
      response.should redirect_to new_user_session_path
    end
  end

  describe '.edit' do
    it 'redirect to login if guest' do
      get :edit
      response.should redirect_to new_user_session_path
    end
  end
end
