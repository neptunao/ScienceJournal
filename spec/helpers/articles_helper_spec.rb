require 'spec_helper'

describe ArticlesHelper do
  it 'assign approved articles' do
    censor1 = FactoryGirl.create(:censor)
    censor2 = FactoryGirl.create(:censor)
    censor3 = FactoryGirl.create(:censor)
    censor_user1 = FactoryGirl.create(:censor_user)
    censor_user2 = FactoryGirl.create(:censor_user)
    censor_user1.person = censor2
    censor_user1.save!
    censor_user2.person = censor3
    censor_user2.is_approved = true
    censor_user2.save!
    approved_censors.count.should be 1
    approved_censors[0].should eql censor3
  end
end