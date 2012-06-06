require 'spec_helper'

describe 'Censor' do
  before :all do
    User.destroy_all
    Censor.destroy_all
    Article.destroy_all
    @censor_user = FactoryGirl.create(:censor_user)
    @censor_user.update_attribute(:is_approved, true)
    @censor = FactoryGirl.create(:censor)
    @censor_user.update_attribute(:person, @censor)

    @article = create_article
    @article.update_attribute :status, Article::STATUS_TO_REVIEW
    @article.update_attribute :censor_id, @censor.id
  end

  before :each do
    login @censor_user
  end

  after :each do
    visit 'logout'
  end

  it 'have access to his article' do
    visit article_path(@article)
    current_url.should eql article_path @article
  end

  it 'have access to edit article' do
    visit edit_article_path(@article)
    response.should be_success
    current_url.should eql edit_article_path @article
  end

  it 'dont show article authors' do
    visit article_path @article
    response.should_not have_selector 'ul', id: 'authors'
  end
end