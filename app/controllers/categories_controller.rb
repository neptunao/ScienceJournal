class CategoriesController < ApplicationController
  include TheSortableTreeController::Rebuild
  before_filter :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource

  def new
    @category = Category.new
  end

  def index
    @categories = Category.nested_set.all
  end

  def show

  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    Category.find(params[:id]).destroy
    redirect_to root_path
  end
end
