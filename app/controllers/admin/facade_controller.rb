class Admin::FacadeController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_user_not_admin
  
  def index
    @lessons = Lesson.all
    @users = User.all
    @bookings = Booking.all
  end
end