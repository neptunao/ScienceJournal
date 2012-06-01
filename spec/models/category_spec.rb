require 'spec_helper'

describe Category do
  it 'must have title' do
    Category.new().should_not be_valid
  end
end
