class Admin::FacadeController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_user_not_admin
  before_action :all_bookings, :all_lessons, :all_users, only: [:index]
  
  def index
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  private

  def all_bookings
    @bookings = Booking.all.sort.reverse
  end

  def all_lessons
    @lessons = Lesson.all.sort.reverse
  end

  def all_users
    @users = User.where(is_admin: false).all.sort.reverse
  end
end
