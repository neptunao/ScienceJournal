require 'spec_helper'

describe 'Abilities of' do
  def guest_user_ability
    Ability.new(@guest_user)
  end

  def author_user_ability
    Ability.new(@author_user)
  end

  def censor_user_ability
    Ability.new(@censor_user)
  end

  before :all do
    DataFile.destroy_all
    User.destroy_all
    load_roles
    @guest_user = FactoryGirl.build(:guest_user)
    @author_user = FactoryGirl.create(:user)
    @censor_user = FactoryGirl.create(:censor_user)
    @censor_user.person = FactoryGirl.create(:censor)
  end

  after :all do
    User.destroy_all
    Author.destroy_all
  end

  before :each do
    @author_user.person = nil
    @censor_user.update_attribute(:is_approved, true)
  end

  it 'admin can manage all' do
    Ability.new(FactoryGirl.create(:admin_user)).should be_can(:manage, :all)
  end

  it 'non-admin users cant get access to update_without_password' do
    guest_user_ability.should_not be_can(:update_without_password, @guest_user)
    author_user_ability.should_not be_can(:update_without_password, @author_user)
    censor_user_ability.should_not be_can(:update_without_password, @censor_user)
  end

  it 'only author can get access to authors/new' do
    guest_user_ability.should_not be_can(:new, Author)
    author_user_ability.should be_can(:new, Author)
    censor_user_ability.should_not be_can(:new, Author)
  end

  it 'author user only without author association can get access to authors/new' do
    @author_user.person = FactoryGirl.create(:author)
    author_user_ability.should_not be_can(:new, Author)
  end

  it 'only author can get access to authors/create' do
    guest_user_ability.should_not be_can(:create, Author)
    author_user_ability.should be_can(:create, Author)
    censor_user_ability.should_not be_can(:create, Author)
  end

  it 'author user only without author association can get access to authors/create' do
    @author_user.person = FactoryGirl.create(:author)
    author_user_ability.should_not be_can(:create, Author)
  end

  it 'all can get access to authors/show' do
    guest_user_ability.should be_can(:show, Author)
    author_user_ability.should be_can(:show, Author)
    censor_user_ability.should be_can(:show, Author)
  end

  it 'only current author can get access to athors/edit' do
    guest_user_ability.should_not be_can(:update, Author)
    author_user_ability.should_not be_can(:update, Author)
    censor_user_ability.should_not be_can(:update, Author)

    @author_user.person = FactoryGirl.create(:author)
    author_user_ability.should be_can(:update, @author_user.person)
  end

  it 'only author can create new articles' do
    guest_user_ability.should_not be_can(:create, Article)
    author_user_ability.should be_can(:create, Article)
    censor_user_ability.should_not be_can(:create, Article)
  end

  it 'censor can read only articles that he own' do
    article = Article.create(censor_id: @censor_user.person.id)
    article1 = Article.new
    censor_user_ability.should be_can(:read, article)
    censor_user_ability.should_not be_can(:read, article1)
  end

  it 'unapproved user can noting' do
    article = Article.create(censor_id: @censor_user.person.id)
    @censor_user.is_approved = false
    censor_user_ability.should_not be_can(:read, article)
  end

  it 'author can read only own articles' do
    @author_user.person = FactoryGirl.create(:author)
    article = Article.create(author_ids: [@author_user.person.id])
    article1 = Article.new
    author_user_ability.should be_can(:read, article)
    author_user_ability.should_not be_can(:read, article1)
  end

  it 'only admin can create journals' do
    guest_user_ability.should_not be_can(:create, Journal)
    author_user_ability.should_not be_can(:create, Journal)
    censor_user_ability.should_not be_can(:create, Journal)
  end

  it 'all can read journals' do
    guest_user_ability.should be_can(:read, Journal)
    author_user_ability.should be_can(:read, Journal)
    censor_user_ability.should be_can(:read, Journal)
  end

  it 'all can read approved articles' do
    a2 = create_article
    a2.update_attribute(:status, Article::STATUS_APPROVED)
    guest_user_ability.should be_can(:read, a2)
    author_user_ability.should be_can(:read, a2)
    censor_user_ability.should be_can(:read, a2)
  end

  it 'guest cant read unapproved articles' do
    guest_user_ability.should_not be_can(:read, create_article)
  end

  it 'all can read categories' do
    guest_user_ability.should be_can(:read, Category)
    author_user_ability.should be_can(:read, Category)
    censor_user_ability.should be_can(:read, Category)
  end

  it 'only admin can create category' do
    guest_user_ability.should_not be_can(:create, Category)
    author_user_ability.should_not be_can(:create, Category)
    censor_user_ability.should_not be_can(:create, Category)
  end

  it 'only admin can update category' do
    guest_user_ability.should_not be_can(:update, Category)
    author_user_ability.should_not be_can(:update, Category)
    censor_user_ability.should_not be_can(:update, Category)
  end

  it 'only admin can destroy category' do
    guest_user_ability.should_not be_can(:destroy, Category)
    author_user_ability.should_not be_can(:destroy, Category)
    censor_user_ability.should_not be_can(:destroy, Category)
  end

  it 'censor can update his articles' do
    article = create_article
    article.update_attribute(:censor_id, @censor_user.person.id)
    article.update_attribute(:status, Article::STATUS_TO_REVIEW)
    censor_user_ability.should be_can :update, article
  end

  it 'censor cant update no his articles' do
    article = create_article
    censor_user_ability.should_not be_can :update, article
  end

  it 'censor cant update articles with no-review status' do
    article = create_article
    article.update_attribute(:censor_id, @censor_user.person.id)
    censor_user_ability.should_not be_can :update, article
  end

  it 'unapproved censor cant update articles' do
    article = create_article
    article.update_attribute(:censor_id, @censor_user.person.id)
    article.update_attribute(:status, Article::STATUS_TO_REVIEW)
    @censor_user.update_attribute(:is_approved, false)
    censor_user_ability.should_not be_can :update, article
  end

  it 'unapproved censor cant read articles' do
    article = create_article
    article.update_attribute(:censor_id, @censor_user.person.id)
    article.update_attribute(:status, Article::STATUS_TO_REVIEW)
    @censor_user.update_attribute(:is_approved, false)
    censor_user_ability.should_not be_can :read, article
  end
end