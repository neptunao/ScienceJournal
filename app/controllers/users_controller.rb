class UsersController < ApplicationController
  before_filter :authenticate_user!, only: [:update_without_password] #TODO integration tests
  def index
    @users = User.where(is_approved: params[:approved])
    authorize! :read, @users
  end
  def update_without_password
    begin
      authorize! :update_without_password, :all
      params[:approved].each {|p| User.find(p[0]).update_attribute(:is_approved, p[1]) }
      redirect_to root_url
    rescue CanCan::AccessDenied
      redirect_to root_url
    end
  end
end
