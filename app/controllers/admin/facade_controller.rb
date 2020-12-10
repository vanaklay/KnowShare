class Admin::FacadeController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_user_not_admin
  
  def index
    @lessons = Lesson.all.sort.reverse
    @users = User.where(is_admin: false).all.sort.reverse
    @bookings = Booking.all.sort.reverse

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end
end