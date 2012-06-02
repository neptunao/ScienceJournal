require 'spec_helper'
include Devise::TestHelpers

describe 'Autorization' do
  before :all do
    DataFile.destroy_all
    User.destroy_all
    @user = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:admin_user)
  end

  it 'change sign in link to sign out' do
    login @user
    response.should_not have_selector 'a', href: '/login', content: 'Sign in'
    response.should_not have_selector 'a', href: '/register', content: 'Sign up'
    response.should_not have_selector 'a', href: articles_path(status: Article::STATUS_CREATED)
    response.should have_selector 'a', href: '/logout', content: 'Sign out'
    response.should have_selector 'a', href: '/profile/show'
    response.should have_selector 'a', href: '/profile/edit_personal'
  end
  it 'change sign out link to sign in' do
    login @user
    visit '/logout'
    response.should_not have_selector 'a', href: '/logout', content: 'Sign out'
    response.should_not have_selector 'a', href: '/profile/show'
    response.should_not have_selector 'a', href: '/profile/edit_personal'
    response.should_not have_selector 'a', href: articles_path(status: Article::STATUS_CREATED)
    response.should have_selector 'a', href: '/login', content: 'Sign in'
    response.should have_selector 'a', href: '/register', content: 'Sign up'
  end

  it 'render admin links' do
    login @admin
    response.should have_selector 'a', href: articles_path(status: Article::STATUS_CREATED)
  end

  it 'edit profile page contains name field' do
    login @user
    visit edit_user_registration_path(@user)
    response.should have_selector 'input', name: 'user[name]'
  end
  it 'register page contains name field' do
    visit new_user_registration_path
    response.should have_selector 'input', name: 'user[name]'
  end
  it 'register page contains type field' do
    visit new_user_registration_path
    assert_tag tag: 'select', attributes: { name: 'user[role_ids]' }, children: { count: 2 }
    response.should have_selector 'select option', value: Role.author_role.id.to_s
    response.should have_selector 'select option', value: Role.censor_role.id.to_s
  end
end