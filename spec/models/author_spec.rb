require 'spec_helper'

describe Author do
  it 'should have last name' do
    Author.new(last_name: nil, first_name: 'test', middle_name: 'test').should_not be_valid
  end
  it 'should have first name' do
    Author.new(last_name: 'test', first_name: nil, middle_name: 'test').should_not be_valid
  end
end
