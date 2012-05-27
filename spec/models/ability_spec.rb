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
    User.destroy_all
    load "#{Rails.root}/db/seeds.rb"
    @guest_user = FactoryGirl.build(:guest_user)
    @author_user = FactoryGirl.create(:user)
    @censor_user = FactoryGirl.build(:censor_user)
    @censor_user.person = FactoryGirl.create(:censor)
  end

  after :all do
    User.destroy_all
    Author.destroy_all
  end

  before :each do
    @author_user.person = nil
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
end