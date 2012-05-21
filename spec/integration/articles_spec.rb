require 'spec_helper'
include Devise::TestHelpers

describe 'Articles' do
  it 'checkbox change visibility of review' do
    visit new_article_path
    pending 'todo with capybara find'
  end
end