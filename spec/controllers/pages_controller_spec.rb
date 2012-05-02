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
      response.should have_selector('a', href: '/login', content: 'Login' )
    end
    it 'contains register link' do
      get 'home'
      response.should have_selector('a', href: '/register', content: 'Register')
    end
  end

end
