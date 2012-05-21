require 'spec_helper'

describe ArticlesController do
  describe '.new' do
    it 'assigns new article to @article' do
      get :new
      assigns(:article).should be_a_new(Article)
    end
  end
end
