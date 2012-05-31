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
    data_files = []
    add_file_and_delete_param(files: data_files, params_hash: j_params, key: :journal_file, tag: Journal::JOURNAL_FILE_TAG)
    add_file_and_delete_param(files: data_files, params_hash: j_params, key: :cover_image, tag: Journal::COVER_IMAGE_FILE_TAG)
    j_params = j_params.merge({ data_files: data_files })
    @journal = Journal.new(j_params)
    if @journal.save
      redirect_to root_path
    else
      @journal.destroy
      render :new
    end
  end

  def add_file_and_delete_param(params)
    hash = params[:params_hash]
    key = params[:key]
    if hash[key]
      params[:files] << DataFile.upload(hash[key], params[:tag])
      hash.delete(key)
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
