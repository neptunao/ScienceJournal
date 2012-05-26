class ArticlesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :precreate_article, only: :create
  load_and_authorize_resource

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
    @article = Article.new(title: params[:article][:title], data_files: data_files, authors: [current_user.person])
    if @article.save
      redirect_to root_path
    else
      @article.data_files.destroy_all
      @article.censor = Censor.new if @article.censor.nil?
      render :new
    end
  end

  private

  def precreate_article
    @article = Article.new
    @article.censor = Censor.new
  end
end
