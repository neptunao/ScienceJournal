require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end
    it 'contains login link' do
      get 'home'
      response.should have_selector('a', href: '/login', content: 'Sign in' )
    end
    it 'contains register link' do
      get 'home'
      response.should have_selector('a', href: '/register', content: 'Sign up')
    end
    it 'contains home link' do
      get 'home'
      response.should have_selector('a', href: '/', content: 'Home')
    end
    it 'contains categories tree' do
      get 'home'
      response.should have_selector('div#tree')
    end
  end

end
