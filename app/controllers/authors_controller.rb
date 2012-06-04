class AuthorsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def show
    @author = Author.find(params[:id])
  end

  def new
    @author = Author.new
  end

  def edit
    @author = Author.find(params[:id])
  end

  def create
    @author = Author.new(params[:author])
    if @author.save
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    @author = Author.find(params[:id])
    if @author.update_attributes(params[:author])
      redirect_to root_path
    else
      render :edit
    end
  end
end
