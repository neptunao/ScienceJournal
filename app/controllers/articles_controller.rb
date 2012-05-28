class ArticlesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :initialize_assigns, only: [:create, :index, :new]
  load_and_authorize_resource

  def index
    exp = params.select { |k, v| k == 'status' || k == 'censor_id' }
    @articles = Article.where(exp) unless params[:status].nil?
  end

  def new
    if current_user.person.nil?
      flash[:notice] = 'You must fill personal information before create new article.'
      return redirect_to edit_personal_path
    end
    @article = Article.new
    @article.censor = Censor.new
  end

  def create  #TODO refactoring
    files = params[:article][:data_files]
    data_files = []
    unless files.nil?
      data_files << DataFile.upload(files[:article], Article::ARTICLE_FILE_TAG) unless files[:article].nil?
      data_files << DataFile.upload(files[:resume_rus], Article::RESUME_RUS_FILE_TAG) unless files[:resume_rus].nil?
      data_files << DataFile.upload(files[:resume_eng], Article::RESUME_ENG_FILE_TAG) unless files[:resume_eng].nil?
      data_files << DataFile.upload(files[:cover_note], Article::COVER_NOTE_FILE_TAG) unless files[:cover_note].nil?
    end

    authors_ids = params[:article][:author_ids] << current_user.person.id

    censor = nil
    invalid_article = false
    status = Article::STATUS_CREATED
    if params[:article][:has_review] == '1'
      if params[:article][:review]
        data_files << DataFile.upload(params[:article][:review], Article::REVIEW_FILE_TAG)
      else
        invalid_article = true
      end
      censor =  Censor.create(params[:article][:censor_attributes])
      status = Article::STATUS_REVIEWED
    end

    @article = Article.new(title: params[:article][:title], data_files: data_files, author_ids: authors_ids, status: status)
    @article.censor = censor

    if @article.save
      redirect_to root_path
    else
      @article.data_files.destroy_all
      @article.censor.destroy if @article.censor
      @article.censor = Censor.new if @article.censor.nil?
      @article.errors.add(:review, 'Missing review attachment.') if invalid_article
      render :new
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def update  #TODO TEST
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      flash[:notice] = 'Article updated successfully.'
      redirect_to root_path
    else
      render :show
    end
  end

  private

  def initialize_assigns
    @article = Article.new
    @article.censor = Censor.new
    @articles = Article.accessible_by(current_ability)  #TODO test
    @authors = Author.select { |a| a.id != current_user.person.id } if current_user.person   #TODO test
  end
end
