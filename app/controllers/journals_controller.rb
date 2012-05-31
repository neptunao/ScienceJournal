class JournalsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :initialize_assigns, only: [:new, :create]
  load_and_authorize_resource

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    j_params = params[:journal]
    if params[:journal][:journal_file]
      data_files = [DataFile.upload(params[:journal][:journal_file], Journal::JOURNAL_FILE_TAG)]
      j_params = params[:journal].merge({ data_files: data_files })
      j_params.delete(:journal_file)
    end
    @journal = Journal.new(j_params)
    if @journal.save
      redirect_to root_path
    else
      @journal.destroy
      render :new
    end
  end

  private

  def initialize_assigns
    @journal = Journal.new
    @articles = Article.where(status: Article::STATUS_APPROVED)
    @articles = Article.where(category_id: params[:journal][:category_id]) if params[:journal] && params[:journal][:category_id]
    @categories = Category.all
  end
end
