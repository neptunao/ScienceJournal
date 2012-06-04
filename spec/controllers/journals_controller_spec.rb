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
    Article.destroy_all
    DataFile.destroy_all
  end

  after :each do
    DataFile.destroy_all
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

      it 'assign approved articles at root category (fixed B12 - articles not show on init journals#new)' do
        a = create_article
        a1 = create_article
        a.update_attribute(:status, Article::STATUS_APPROVED)
        a.update_attribute(:category_id, Category.first!.id)
        a1.update_attribute(:status, Article::STATUS_APPROVED)
        create_article
        get :new
        assigns(:articles).count.should be 1
        assigns(:articles)[0].should eql a
      end

      it 'response with js' do
        get :new, format: :js
        response.should be_success
      end

      it 'assign articles with category_id (fixed B15 - not approved articles show on init journals#new)' do
        a1 = create_article
        a2 = create_article
        category_id = FactoryGirl.create(:category).id
        a1.update_attribute(:category_id, category_id)
        a2.update_attribute(:category_id, category_id)
        a2.update_attribute(:status, Article::STATUS_APPROVED)
        get :new, journal: { category_id: category_id }
        assigns(:articles).count.should be 1
        assigns(:articles)[0].should eql a2
      end
    end
  end

  describe '.create' do
    before :all do
      DataFile.destroy_all
      Article.destroy_all
      @journal_file = fixture_file_upload('/test_data/test_pdf_file.pdf')
      @image_file = fixture_file_upload('/test_data/test_image.jpg')
    end

    before :each do
      @article = create_article
      @category = FactoryGirl.create(:category)
      sign_in @admin_user
    end

    after :each do
      sign_out @admin_user
    end

    def full_params
      { journal: { name: 'a', num: '2', category_id: @category.id, article_ids: [@article.id],
                   journal_file: @journal_file, cover_image: @image_file } }
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

    it 'journal with full_params' do
      expect { post :create, full_params }.to change(Journal, :count).by 1
    end

    it 'cover image file' do
      post :create, full_params
      Journal.last.cover_image.should_not be_nil
    end
  end

  describe '.index' do
    before :each do
      Journal.destroy_all
    end

    describe 'access' do
      it 'not redirect to login if guest' do
        get :index
        response.should_not redirect_to new_user_session_path
      end
    end

    describe 'work' do
      it 'assigns journals' do
        get :index
        create_journal
        create_journal
        assigns(:journals).count.should be 2
        assigns(:journals).should =~ Journal.all
      end

      it 'assign categorized journals' do
        category = FactoryGirl.create(:category)
        create_journal
        j = create_journal
        j.update_attribute(:category_id, category.id)
        get :index, category_id: category.id
        assigns(:journals).should =~ [j]
      end
    end
  end

  describe '.show' do
    before :each do
      Journal.destroy_all
    end

    describe 'access' do
      it 'not redirect to login if guest' do
        get :show
        response.should_not redirect_to new_user_session_path
      end
    end

    describe 'work' do
      it 'assigns journal' do
        j = create_journal
        get :show, id: j.id
        assigns(:journal).should eql j
      end
    end
  end
end
