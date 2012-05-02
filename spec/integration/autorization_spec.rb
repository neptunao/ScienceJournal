require 'spec_helper'
include Devise::TestHelpers

describe 'Autorization' do
  before :each do
    user = User.create(email: 'test@test.com', password: '123456')
    visit '/login'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    click_button 'Sign in'
  end
  it 'change sign in link to sign out' do
    response.should_not have_selector 'a', href: '/login', content: 'Sign in'
    response.should_not have_selector 'a', href: '/register', content: 'Sign up'
    response.should have_selector 'a', href: '/logout', content: 'Sign out'
  end
  it 'change sign out link to sign in' do
    visit '/logout'
    response.should_not have_selector 'a', href: '/logout', content: 'Sign out'
    response.should have_selector 'a', href: '/login', content: 'Sign in'
    response.should have_selector 'a', href: '/register', content: 'Sign up'
  end
end