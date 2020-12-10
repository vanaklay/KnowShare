class TeacherBookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_current_user
  before_action :redirect_if_not_teacher
  before_action :redirect_if_not_author

  def index
  end

  private

  def find_current_user
    @user = current_user
  end

  def redirect_if_not_author
    @find_user = User.find(params[:user_id])
    unless @user == @find_user
      redirect_to @user, warning: "Tu n'es pas propriétaire de ce compte"
    end
  end

  def redirect_if_not_teacher
    unless @user.teacher?
      redirect_to @user, warning: "Tu n'es pas professeur !"
    end
  end
end
