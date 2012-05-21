require 'spec_helper'

describe ProfileController do
  it 'should have show action' do
    get :show
    response.should be_success
  end

  it 'should have edit_personal action' do
    get :edit_personal_info
    response.should be_success
  end
end
