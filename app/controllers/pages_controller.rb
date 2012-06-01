class PagesController < ApplicationController
  layout '_categories'
  before_filter :init_assigns

  def home
    @journals = Journal.all.sort_by { |j| j.created_at }.last(5).reverse
    @articles = Article.select{ |a| a.journal_id != 0 }
  end

  private

  def init_assigns
    @categories = Category.nested_set.all
  end
end
