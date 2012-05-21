class ProfileController < ApplicationController
  before_filter :authenticate_user!

  def show
  end

  def edit_personal_info
  end
end
