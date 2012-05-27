class ArticlesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :initialize_assigns, only: [:create, :index]
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
    files = params[:article][:data_files]
    data_files = []
    unless files.nil?
      data_files << DataFile.upload(files[:article], Article::ARTICLE_FILE_TAG) unless files[:article].nil?
      data_files << DataFile.upload(files[:resume_rus], Article::RESUME_RUS_FILE_TAG) unless files[:resume_rus].nil?
      data_files << DataFile.upload(files[:resume_eng], Article::RESUME_ENG_FILE_TAG) unless files[:resume_eng].nil?
      data_files << DataFile.upload(files[:cover_note], Article::COVER_NOTE_FILE_TAG) unless files[:cover_note].nil?
    end
    coauthors = []
    if params[:article][:authors_attributes]
      params[:article][:authors_attributes].each do |k, v|
        coauthors << Author.create(first_name: v[:first_name], middle_name: v[:middle_name], last_name: v[:last_name])
      end
    end
    @article = Article.new(title: params[:article][:title], data_files: data_files, authors: coauthors << current_user.person)
    if @article.save
      redirect_to root_path
    else
      @article.data_files.destroy_all
      coauthors.each { |a| a.destroy } unless coauthors.empty?
      @article.censor = Censor.new if @article.censor.nil?
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
  end
end
