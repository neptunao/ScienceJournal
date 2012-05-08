require 'spec_helper'

describe User do
  before :each do
    load "#{Rails.root}/db/seeds.rb"
    @admin_user =User.first!
  end
  it 'admin should exist' do
    @admin_user.roles.first.name.should eql 'admin'
  end
  it 'admin can manage all' do
    Ability.new(@admin_user).can?(:manage, :all).should be_true
  end
  it 'name should exists' do
    user = FactoryGirl.create(:user)
    user.name = ''
    user.should_not be_valid
  end
  it 'name should be unique' do
    exist_user = FactoryGirl.create(:user)
    user = User.new(name: exist_user.name, password: exist_user.password, email: exist_user.email + 'a')
    user.should_not be_valid
  end
  it 'type should exists' do
    user = FactoryGirl.create(:user)
    user.user_type = ''
    user.should_not be_valid
  end
  it 'autor should be approved by default' do
    user = User.new(user_type: 'Autor')
    user.should be_is_approved
  end
  it 'censor should not be approved by default' do
    user = User.new(user_type: 'Censor')
    user.should_not be_is_approved
  end
end