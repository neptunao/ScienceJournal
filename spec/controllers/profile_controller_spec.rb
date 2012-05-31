require 'spec_helper'

describe ProfileController do
  before :all do
    DataFile.destroy_all
    User.destroy_all
    load "#{Rails.root}/db/seeds.rb"
    @user = FactoryGirl.create(:user)
  end

  it 'show action should redirect when non-authorized' do
    get :show
    response.should redirect_to new_user_session_path
  end

  it 'edit_personal should redirect when non-authorized' do
    get :edit_personal_info
    response.should redirect_to new_user_session_path
  end

  it 'show action should be successfull when authorized' do
    sign_in @user
    get :show
    response.should be_success
    sign_out @user
  end

  it 'edit_personal action should be successfull when authorized' do
    sign_in @user
    get :edit_personal_info
    response.should be_success
    sign_out @user
  end

  it 'invalid update (create new person) not change person' do
    sign_in @user
    @user.person.should be_nil
    put :update, { user: { person: { first_name: '123' } } }
    @user.reload
    @user.person.should be_nil
    sign_out @user
  end

  it 'invalid update (existing person) not change person' do
    sign_in @user
    @user.update_attribute(:person, FactoryGirl.create(:author))
    expected_id = @user.person.id
    put :update, { user: { person: { first_name: '123' } } }
    @user.reload
    @user.person.id.should be expected_id
    sign_out @user
  end

  it 'invalid update render edit' do
    sign_in @user
    put :update, { user: { person: { } } }
    response.should render_template 'profile/edit_personal_info'
    sign_out @user
  end
end
