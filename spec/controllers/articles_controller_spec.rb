require 'spec_helper'

describe ArticlesController do
  before :all do
    User.destroy_all
    load "#{Rails.root}/db/seeds.rb"
    @author_user = FactoryGirl.create(:user)
    @censor_user = FactoryGirl.create(:censor_user)
    @censor_user.update_attribute(:person, FactoryGirl.create(:censor))
    @users = [@author_user, @censor_user]
    @admin_user = FactoryGirl.create(:admin_user)
    @author = FactoryGirl.create(:author)

    @article_file = fixture_file_upload('/test_data/test_pdf_file.pdf')
    @resume_rus_file = fixture_file_upload('/test_data/test_pdf_file1.pdf')
    @resume_eng_file = fixture_file_upload('/test_data/test_pdf_file2.pdf')
    @cover_note_file = fixture_file_upload('/test_data/test_pdf_file3.pdf')
  end

  after :all do
    User.destroy_all
    DataFile.destroy_all
  end

  def create_user
    user = FactoryGirl.create(:user)
    user.update_attribute(:person, FactoryGirl.create(:author))
    user
  end

  def create_article
    Article.create(title: 'test',
                   data_files: [FactoryGirl.create(:article_file), FactoryGirl.create(:resume_rus), FactoryGirl.create(:resume_eng), FactoryGirl.create(:cover_note)],
                   authors: [FactoryGirl.create(:author)])
  end

  describe '.new' do
    it 'redirect to login if guest' do
      get :new
      response.should redirect_to new_user_session_path
    end

    it 'redirect to root if not author' do
      sign_in @censor_user
      get :new
      response.should redirect_to root_path
      sign_out @censor_user
    end

    it 'assigns new article to @article' do
      sign_in @author_user
      get :new
      assigns(:article).should be_a_new(Article)
      sign_out @author_user
    end

    it 'redirect to edit personal info if user.person is nil' do
      sign_in @author_user
      get :new
      response.should redirect_to edit_personal_path
    end
  end

  describe '.create' do
    before :all do
      @min_params = { article: { title: 'test', data_files: {
          article: @article_file, resume_rus: @resume_rus_file, resume_eng: @resume_eng_file, cover_note: @cover_note_file },
                                 has_review: '0', censor_attributes: { first_name: '', last_name: '' }
      } }
      @full_params = nil
    end

    it 'redirect to login if guest' do
      post :create
      response.should redirect_to new_user_session_path
    end

    it 'redirect to root if not author' do
      sign_in @censor_user
      post :create
      assigns(:article).should be_a_new(Article)
      assigns(:article).censor.should be_a_new(Censor)
      response.should redirect_to root_path
      sign_out @censor_user
    end

    it 'render new if errors' do
      user = create_user
      sign_in user
      post :create, { article: { title: 'test' } }
      response.should render_template 'articles/new'

      post :create, { article: { title: 'test', data_files: { article: @article_file } } }
      response.should render_template 'articles/new'

      post :create, { article: { title: 'test', data_files: { resume_rus: @resume_rus_file } } }
      response.should render_template 'articles/new'

      post :create, { article: { title: 'test', data_files: { resume_eng: @resume_eng_file } } }
      response.should render_template 'articles/new'

      post :create, { article: { title: 'test', data_files: { cover_note: @cover_note_file } } }
      response.should render_template 'articles/new'

      sign_out user
    end

    it 'create new article and redirect to root (min params)' do
      user = create_user
      sign_in user
      expect { post :create, @min_params }.to change(Article, :count).by(1)
      response.should redirect_to root_path
      sign_out user
      DataFile.destroy_all
    end

    it 'delete files if errors' do
      DataFile.destroy_all
      user = create_user
      sign_in user
      post :create, { article: { title: 'test', data_files: { article: @article_file } } }
      DataFile.all.should be_empty
      sign_out user
    end
  end

  describe '.index' do
    before :each do
      Article.destroy_all
      data_files = [FactoryGirl.create(:article_file), FactoryGirl.create(:resume_rus), FactoryGirl.create(:resume_eng), FactoryGirl.create(:cover_note)]
      Article.create(title: 'test', data_files: data_files, authors: [FactoryGirl.create(:author)])
      Article.create(title: 'test',
                         data_files: [FactoryGirl.create(:article_file), FactoryGirl.create(:resume_rus), FactoryGirl.create(:resume_eng), FactoryGirl.create(:cover_note)],
                         authors: [FactoryGirl.create(:author)], status: Article::STATUS_REVIEWED)
      Article.create(title: 'test',
                         data_files: [FactoryGirl.create(:article_file), FactoryGirl.create(:resume_rus), FactoryGirl.create(:resume_eng), FactoryGirl.create(:cover_note)],
                         authors: [FactoryGirl.create(:author)], status: Article::STATUS_TO_REVIEW)
      @censor_article = Article.create(title: 'test',
                         data_files: [FactoryGirl.create(:article_file), FactoryGirl.create(:resume_rus), FactoryGirl.create(:resume_eng), FactoryGirl.create(:cover_note)],
                         authors: [FactoryGirl.create(:author)], status: Article::STATUS_TO_REVIEW, censor_id: @censor_user.person.id)
    end

    it 'redirect to root if not admin' do
      @users.each do |user|
        sign_in user
        get :index
        response.should redirect_to root_path
        sign_out user
      end
    end

    it 'assigns articles without review as @articles' do
      sign_in @admin_user
      get :index, { status: Article::STATUS_CREATED }
      assigns(:articles).should_not be_nil
      assigns(:articles).should_not eql Article.all
      assigns(:articles).should be =~ Article.find_all_by_status(Article::STATUS_CREATED)
      sign_out @admin_user
    end

    it 'assigns articles with review as @articles' do
      sign_in @admin_user
      get :index, { status: Article::STATUS_REVIEWED }
      assigns(:articles).should_not be_nil
      assigns(:articles).should_not eql Article.all
      assigns(:articles).should be =~ Article.where(status: Article::STATUS_REVIEWED)
      sign_out @admin_user
    end

    it 'assigns articles without params as @articles' do
      sign_in @admin_user
      get :index
      assigns(:articles).should_not be_nil
      assigns(:articles).should be =~ Article.all
      sign_out @admin_user
    end

    it 'assigns censor articles as @articles' do
      sign_in @censor_user
      get :index, { status: Article::STATUS_TO_REVIEW, censor_id: @censor_user.person.id }
      assigns(:articles).count.should be 1
      assigns(:articles)[0].should eql @censor_article
      sign_out @censor_user
    end
  end

  describe '.show' do
    it 'assigns @article' do
      sign_in @admin_user
      article = create_article
      get :show, id: article.id
      assigns(:article).should eql article
      sign_out @admin_user
    end
  end
end
