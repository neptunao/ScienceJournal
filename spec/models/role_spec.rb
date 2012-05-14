require 'spec_helper'

describe 'Role' do
  after :all do
    Role.delete_all
  end
  it 'name must exists' do
    Role.new.should_not be_valid
  end
  it 'name should be unique' do
    role1 = Role.create(name: 'role')
    role1.should be_valid
    role2 = Role.new(name: 'role')
    role2.should_not be_valid
  end
end