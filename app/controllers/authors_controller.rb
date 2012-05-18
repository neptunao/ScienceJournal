class AuthorsController < ApplicationController
  def index #TODO

  end

  def show  #TODO

  end

  def new
    @author = Author.new
  end

  def edit  #TODO

  end

  def create
    @author = Author.new(params[:author])
    if @author.save
      redirect_to root_path
    else
      render :new
    end
  end

  def update #TODO

  end

  def destroy #TODO

  end
end
