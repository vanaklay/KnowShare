class Admin::FacadeController < ApplicationController
  def index
    @lessons = Lesson.all
    @users = User.all
    @bookings = Booking.all
  end
end