require 'spec_helper'

describe 'Layout' do
  it 'render errors' do
    visit new_author_path
    click_button 'Create Author'
    response.should have_selector 'div', class: 'alert alert-error'
    assigns(:author).errors.full_messages.each do |m|
      response.should have_selector 'li', content: m
    end
  end
end