require 'spec_helper'

describe ArticlesController do
  before :all do
    User.destroy_all
    load "#{Rails.root}/db/seeds.rb"
    @author_user = FactoryGirl.create(:user)
    @censor_user = FactoryGirl.create(:censor_user)
    @users = [@author_user, @censor_user]
    @admin_user = FactoryGirl.create(:admin_user)
    @author = FactoryGirl.create(:author)
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
      @article_file = fixture_file_upload('/test_data/test_pdf_file.pdf')
      @resume_rus_file = fixture_file_upload('/test_data/test_pdf_file1.pdf')
      @resume_eng_file = fixture_file_upload('/test_data/test_pdf_file2.pdf')
      @cover_note_file = fixture_file_upload('/test_data/test_pdf_file3.pdf')
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
end
