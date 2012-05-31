require 'spec_helper'

describe User do
  before :each do
    DataFile.destroy_all
    load "#{Rails.root}/db/seeds.rb"
  end

  def admin_user
    User.find_by_name('admin')
  end

  it 'admin should exist' do
    admin_user.roles.first.should_not be_nil
    admin_user.roles.first.name.should eql 'admin'
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

  it 'author should be approved by default' do
    user = FactoryGirl.create(:user)
    user.should be_is_approved
  end

  it 'admin should be approved by default' do
    admin_user.should be_is_approved
  end

  it 'censor should not be approved by default' do
    user = FactoryGirl.create(:censor_user)
    user.should_not be_is_approved
  end

  it 'should have user role by default' do
    user = User.new
    user.roles.should =~ [Role.guest_role]
  end
end