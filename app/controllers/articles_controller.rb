class ArticlesController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]
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

  def create
    begin
      data_files = assign_data_files(params[:article][:data_files])
      authors_ids = params[:article][:author_ids] << current_user.person.id
      censor = nil
      invalid_review = false
      status = Article::STATUS_CREATED
      censor, invalid_review, status = assign_review(data_files) if params[:article][:has_review] == '1'
      @article = Article.new(title: params[:article][:title], data_files: data_files, author_ids: authors_ids, status: status, category_id: params[:article][:category_id])
      @article.censor = censor
      if @article.save
        redirect_to root_path
      else
        render_if_invalid(invalid_review: invalid_review)
      end
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = e.message
      render_if_invalid(invalid_review: invalid_review)
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

  def assign_data_files(files)
    data_files = []
    unless files.nil?
      data_files << DataFile.upload(files[:article], Article::ARTICLE_FILE_TAG) unless files[:article].nil?
      data_files << DataFile.upload(files[:resume_rus], Article::RESUME_RUS_FILE_TAG) unless files[:resume_rus].nil?
      data_files << DataFile.upload(files[:resume_eng], Article::RESUME_ENG_FILE_TAG) unless files[:resume_eng].nil?
      data_files << DataFile.upload(files[:cover_note], Article::COVER_NOTE_FILE_TAG) unless files[:cover_note].nil?
    end
    data_files
  end

  def assign_review(data_files)
    invalid_review = params[:article][:review].nil?
    data_files << DataFile.upload(params[:article][:review], Article::REVIEW_FILE_TAG) if params[:article][:review]
    censor = Censor.create(params[:article][:censor_attributes])
    status = Article::STATUS_REVIEWED
    return censor, invalid_review, status
  end

  def render_if_invalid(params)
    @article.data_files.destroy_all
    @article.censor.destroy if @article.censor
    @article.censor = Censor.new if @article.censor.nil?
    @article.errors.add(:review, 'attachment is missing.') if params[:invalid_review]
    render :new
  end

  def initialize_assigns
    @article = Article.new
    @article.censor = Censor.new
    @articles = Article.select {|a| can? :read, a } #TODO test
    @authors = Author.select { |a| a.id != current_user.person.id } if current_user && current_user.person   #TODO test
  end
end
