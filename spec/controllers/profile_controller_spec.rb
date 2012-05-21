require 'spec_helper'

describe ProfileController do
  before :all do
    User.destroy_all
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
end
