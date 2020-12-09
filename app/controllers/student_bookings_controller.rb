class StudentBookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_current_user
  before_action :redirect_if_not_author
  before_action :past_student_bookings, :future_student_bookings

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

  def past_student_bookings
    @past_student_bookings = @user.bookings.select { |booking| booking.start_date < DateTime.now }
  end

  def future_student_bookings
    @future_student_bookings = @user.bookings.select { |booking| booking.start_date > DateTime.now }
  end
end
