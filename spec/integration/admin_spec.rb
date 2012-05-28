require 'spec_helper'
include Devise::TestHelpers

describe 'Admin' do
  before :all do
    User.delete_all
    load "#{Rails.root}/db/seeds.rb"
    @user1 = FactoryGirl.create(:censor_user)
    @user2 = FactoryGirl.create(:censor_user, name: @user1.name + '1', email: @user1.email + 'a')
    @user3 = FactoryGirl.create(:censor_user, name: @user1.name + '2', email: @user1.email + 'b')
    @users = [@user1, @user2, @user3]
    @admin = FactoryGirl.create(:admin_user)
  end
  before :each do
    visit '/login'
    fill_in 'Email', with: @admin.email
    fill_in 'Password', with: @admin.password
    click_button 'Sign in'
  end
  after :all do
    visit logout_path
    User.delete_all
  end
  it 'cabinet page contains pending registrations link' do
    visit '/cabinet'
    response.should have_selector 'a', href: '/users?approved=false', content: 'Pending registrations'
  end
  it 'approved users page contains list of unapproved users' do
    visit '/users?approved=false'
    @users.each do |user|
      response.should have_selector 'a', href: edit_user_registration_path(user), content: user.name
      response.should have_selector 'input', name: "approved[#{user.id}]", type: 'checkbox'
      response.should have_selector 'label', content: user.email
      response.should have_selector 'input', type: 'submit'
    end
  end
  it 'approved user' do
    visit '/users?approved=false'
    check("approved[#{@user1.id}]")
    check("approved[#{@user2.id}]")
    check("approved[#{@user3.id}]")
    click_button 'Save'
    @users.each { |user| user.reload }
    @user1.should be_is_approved
    @user2.should be_is_approved
    @user3.should be_is_approved
  end
  it 'show message when all user approved' do
    User.where(is_approved: false).each { |user| user.update_attribute(:is_approved, true) }
    visit '/users?approved=false'
    response.should_not have_selector 'input', type: 'submit'
    response.should have_selector 'p'
  end

  it 'attach article to censor' do
    censor = FactoryGirl.create(:censor)
    article = Article.create(title: 'test',
                   data_files: [FactoryGirl.create(:article_file), FactoryGirl.create(:resume_rus), FactoryGirl.create(:resume_eng), FactoryGirl.create(:cover_note)],
                   author_ids: [FactoryGirl.create(:author).id])
    visit article_path(article)
    select censor.fullname, from: "article[censor_id]"
    click_button 'Update Article'
    article.reload
    article.censor.should eql censor
    article.status.should be Article::STATUS_TO_REVIEW
  end

  it 'approve reviewed article' do
    article = Article.create(title: 'test',
                   data_files: [FactoryGirl.create(:article_file), FactoryGirl.create(:resume_rus), FactoryGirl.create(:resume_eng), FactoryGirl.create(:cover_note)],
                   author_ids: [FactoryGirl.create(:author).id], status: Article::STATUS_REVIEWED)
    visit article_path(article)
    check 'article[status]'
    click_button 'Update Article'
    article.reload
    article.status.should be Article::STATUS_APPROVED
  end
end