require 'spec_helper'

describe JournalsController do
  before :all do
    User.destroy_all

    @author_user = FactoryGirl.create(:user)
    @censor_user = FactoryGirl.create(:censor_user)
    @users = [@author_user, @censor_user]
    @admin_user = FactoryGirl.create(:admin_user)

    article_file = DataFile.create(filename: '1test1', tag: Article::ARTICLE_FILE_TAG)
    resume_rus_file = DataFile.create(filename: '2test2', tag: Article::RESUME_RUS_FILE_TAG)
    resume_eng_file = DataFile.create(filename: '3test3', tag: Article::RESUME_ENG_FILE_TAG)
    cover_note_file = DataFile.create(filename: '4test4', tag: Article::COVER_NOTE_FILE_TAG)
    @data_files = [article_file, resume_rus_file, resume_eng_file, cover_note_file]
  end

  before :each do
    Category.destroy_all
    Article.destroy_all
    DataFile.destroy_all
  end

  def create_article
    Article.create!(title: 'test',
                   data_files: [FactoryGirl.create(:article_file), FactoryGirl.create(:resume_rus), FactoryGirl.create(:resume_eng), FactoryGirl.create(:cover_note)],
                   author_ids: [FactoryGirl.create(:author).id])
  end

  describe '.new' do
    describe 'access' do
      it 'redirect to login if guest' do
        get :new
        response.should redirect_to new_user_session_path
      end

      it 'redirect to root if not admin' do
        sign_in @author_user
        get :new
        response.should redirect_to root_path
        sign_out @author_user
      end
    end

    describe 'work' do
      before :each do
        sign_in @admin_user
      end

      after :each do
        sign_out @admin_user
      end

      it 'assign new journal' do
        get :new
        assigns(:journal).should be_a_new(Journal)
      end

      it 'assign categories' do
        2.times { FactoryGirl.create(:category) }
        get :new
        assigns(:categories).should_not be_nil
        assigns(:categories).should =~ Category.all
      end

      it 'assign approved articles' do
        get :new
        a = create_article
        a.update_attribute(:status, Article::STATUS_APPROVED)
        create_article
        assigns(:articles).count.should be 1
        assigns(:articles)[0].should eql a
      end

      it 'assign articles with category_id' do
        a1 = create_article
        a2 = create_article
        category_id = FactoryGirl.create(:category).id
        a1.update_attribute(:category_id, FactoryGirl.create(:category).id)
        a2.update_attribute(:category_id, category_id)
        get :new, journal: { category_id: category_id }
        assigns(:articles).count.should be 1
        assigns(:articles)[0].should eql a2
      end

      it 'response with js' do
        get :new, format: :js
        response.should be_success
      end
    end
  end

  describe '.create' do
    before :all do
      DataFile.destroy_all
      Article.destroy_all
      Category.destroy_all
      @journal_file = fixture_file_upload('/test_data/test_pdf_file.pdf')
    end

    before :each do
      @article = create_article
      @category = FactoryGirl.create(:category)
      sign_in @admin_user
    end

    after :each do
      sign_out @admin_user
    end

    def min_params
      { journal: { name: 'a', num: '2', category_id: @category.id, article_ids: [@article.id], journal_file: @journal_file } }
    end

    it 'journal' do
      expect { post :create, min_params }.to change(Journal, :count).by 1
    end

    it 'redirect to root if success' do
      post :create, min_params
      response.should redirect_to root_path
    end

    it 'render new if invalid' do
      invalid_params = min_params
      invalid_params[:journal].delete(:journal_file)
      post :create, invalid_params
      response.should render_template 'journals/new'
    end

    it 'destroy data_files if invalid' do
      invalid_params = min_params
      invalid_params[:journal].delete(:journal_file)
      post :create, invalid_params
      DataFile.count.should be 4
    end
  end
end
