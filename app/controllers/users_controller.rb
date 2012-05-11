class UsersController < ApplicationController
  def index
    @users = User.where(is_approved: params[:approved])
  end
  def update_without_password
    params[:approved].each {|p| User.find(p[0]).update_attribute(:is_approved, p[1]) }
    redirect_to root_url
  end
end
