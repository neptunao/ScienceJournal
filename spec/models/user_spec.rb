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
end