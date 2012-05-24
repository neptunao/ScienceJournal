class ArticlesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def new
    @article = Article.new
  end
end
