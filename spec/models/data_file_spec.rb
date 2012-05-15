require 'spec_helper'

describe DataFile do
  after :all do
    DataFile.delete_all
  end
  it 'filename should exists' do
    DataFile.new(filename: '').should_not be_valid
  end
  it 'filename should be unique' do
    DataFile.create(filename: '1')
    DataFile.new(filename: '1').should_not be_valid
  end
end
