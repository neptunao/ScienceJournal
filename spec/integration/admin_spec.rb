require 'spec_helper'
include Devise::TestHelpers

describe 'Admin' do
  before :all do
    DataFile.destroy_all
    User.destroy_all
    load_roles
    @user1 = FactoryGirl.create(:censor_user)
    @user2 = FactoryGirl.create(:censor_user, name: @user1.name + '1', email: @user1.email + 'a')
    @user3 = FactoryGirl.create(:censor_user, name: @user1.name + '2', email: @user1.email + 'b')
    @users = [@user1, @user2, @user3]
    @admin = FactoryGirl.create(:admin_user)
  end

  def create_article(params)
    Article.create(title: 'test',
                       data_files: [FactoryGirl.create(:article_file), FactoryGirl.create(:resume_rus), FactoryGirl.create(:resume_eng), FactoryGirl.create(:cover_note)],
                       author_ids: [FactoryGirl.create(:author).id], status: params[:status], category_id: FactoryGirl.create(:category).id)
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
  it 'approved users page contains list of unapproved users' do
    visit '/users?approved=false'
    @users.each do |user|
      response.should have_selector 'a', href: show_user_path(user), content: user.name
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
    Censor.destroy_all
    censor = FactoryGirl.create(:censor)
    censor.user = FactoryGirl.create(:censor_user)
    censor.user.update_attribute :is_approved, true
    censor.save!
    article = create_article(status: Article::STATUS_CREATED)
    visit edit_article_path(article)
    select censor.fullname, from: "article[censor_id]"
    click_button 'Update Article'
    article.reload
    article.censor.should eql censor
    article.status.should be Article::STATUS_TO_REVIEW
  end

  it 'approve reviewed article' do
    article = create_article(status: Article::STATUS_REVIEWED)
    article.data_files << FactoryGirl.create(:review)
    article.save!
    visit edit_article_path(article)
    choose "article_status_#{Article::STATUS_APPROVED}"
    click_button 'Update Article'
    article.reload
    article.status.should be Article::STATUS_APPROVED
  end

  it 'reject reviewed article' do
    article = create_article(status: Article::STATUS_REVIEWED)
    article.data_files << FactoryGirl.create(:review)
    article.save!
    visit edit_article_path(article)
    choose "article_status_#{Article::STATUS_REJECTED}"
    click_button 'Update Article'
    article.reload
    article.status.should be Article::STATUS_REJECTED
  end

  it 'B6 - exception when admin request edit_personal_info' do
    visit edit_personal_path
    current_url.should eql show_profile_url
  end
end