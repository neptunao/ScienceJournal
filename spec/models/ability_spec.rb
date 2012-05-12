require 'spec_helper'

describe 'Abilities of' do
  before :all do
    load "#{Rails.root}/db/seeds.rb"
    @guest_user = FactoryGirl.build(:guest_user)
    @guest_user_ability = Ability.new(@guest_user)
    @author_user = FactoryGirl.build(:user)
    @author_user_ability = Ability.new(@author_user)
    @censor_user = FactoryGirl.build(:censor_user)
    @censor_user_ability = Ability.new(@censor_user)
  end
  after :all do
    User.delete_all
  end
  it 'admin can manage all' do
    Ability.new(FactoryGirl.create(:admin_user)).should be_can(:manage, :all)
  end
  it 'non-admin users cant get access to update_without_password' do
    @guest_user_ability.should_not be_can(:update_without_password, @guest_user)
    @author_user_ability.should_not be_can(:update_without_password, @author_user)
    @censor_user_ability.should_not be_can(:update_without_password, @censor_user)
  end
end