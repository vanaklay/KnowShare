class TeacherBookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_current_user
  before_action :redirect_if_not_author
  before_action :teacher_bookings
  before_action :past_teacher_bookings, :future_teacher_bookings

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
  
  def teacher_bookings
    @teacher_bookings = []
    @user.lessons.each do |lesson|
      lesson.bookings.each { |booking| @teacher_bookings << booking }
    end
  end

  def past_teacher_bookings
    @past_teacher_bookings = @teacher_bookings.select { |booking| booking.start_date < DateTime.now }
  end

  def future_teacher_bookings
    @future_teacher_bookings = @teacher_bookings.select { |booking| booking.start_date > DateTime.now }
  end
end
