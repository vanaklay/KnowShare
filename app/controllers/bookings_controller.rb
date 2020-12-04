class BookingsController < ApplicationController
  include BookingsHelper
  before_action :authenticate_user!, only: [:create]
  before_action :find_booking, only: [:destroy]
  
  def create
    @booking = Booking.new(booking_params)
    @booking.followed_lesson_id = params[:lesson_id]
    @booking.duration = 30
    @booking.user_id = current_user.id
    prevent_teacher_booking

    if @booking.save
      flash[:success] = "Votre réservation a bien été prise en compte"
      redirect_to(root_path)
    else
      flash[:danger] = "Votre réservation n'a pas pu aboutir"
      redirect_back(fallback_location: root_path)
    end
  end 

  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: "Le cours a bien été annulé" }
      format.json { head :no_content }
      format.js {}
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date)
  end
end
