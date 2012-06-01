class CategoriesController < ApplicationController
  include TheSortableTreeController::Rebuild

  def index
    @categories = Category.nested_set.all
  end

  def show

  end
end
