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
end
