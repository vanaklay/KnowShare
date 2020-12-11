class StudentBookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_current_user
  before_action :redirect_if_not_author

  def index
  end

  private

  def find_current_user
    @user = current_user
  end

  def redirect_if_not_author
    @find_user = User.find_by(username: params[:user_username])
    unless @user == @find_user
      redirect_to @user, warning: "Tu n'es pas propriétaire de ce compte"
    end
  end
end
