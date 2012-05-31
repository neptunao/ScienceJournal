class JournalsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def new
    @journal = Journal.new
    @articles = Article.where(status: Article::STATUS_APPROVED)
    @articles = Article.where(category_id: params[:journal][:category_id]) if params[:journal] && params[:journal][:category_id]
    @categories = Category.all
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create

  end
end
