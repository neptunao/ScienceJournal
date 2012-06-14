class SearchController < ApplicationController
  def search
    @articles = Article.search title: params[:search]
    @journals = Journal.search_by_name params[:search]
  end
end
