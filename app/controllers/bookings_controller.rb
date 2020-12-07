require 'securerandom'

class BookingsController < ApplicationController
  include BookingsHelper
  before_action :authenticate_user!, only: [:create]
  before_action :find_booking, only: [:destroy]
  
  def create
    @booking = Booking.new(booking_params)
    @booking.lesson_id = params[:lesson_id]
    @booking.user_id = current_user.id
    
    if @booking.start_must_be_in_schedule
      
      if teacher?
        prevent_teacher_booking
      else
        if @booking.save
          Chatroom.create(identifier: SecureRandom.hex, booking_id: @booking.id)
          flash[:success] = "Votre réservation a bien été prise en compte"
          redirect_to current_user
        else
          flash[:danger] = "Votre réservation n'a pas pu aboutir"
          redirect_back(fallback_location: root_path)
        end
      end
    else
      flash[:danger] = "Aucun créneau horaire ne correspond"
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
    params.require(:booking).permit(:start_date, :duration)
  end

end
