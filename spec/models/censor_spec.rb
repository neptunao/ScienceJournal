require 'spec_helper'

describe Censor do
  before :each do
    @censor = FactoryGirl.build(:censor)
  end

  it 'should have last name' do
    @censor.last_name = nil
    @censor.should_not be_valid
  end

  it 'should have first name' do
    @censor.first_name = nil
    @censor.should_not be_valid
  end

  it 'should have degree' do
    @censor.degree = nil
    @censor.should_not be_valid
  end

  it 'should have post' do
    @censor.post = nil
    @censor.should_not be_valid
  end
end
