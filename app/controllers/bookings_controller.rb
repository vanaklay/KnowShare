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
          Credit::Remove.new(amount: @booking.price, user: @booking.student).call
          Chatroom.create(identifier: SecureRandom.hex, booking_id: @booking.id)
          @booking.split_and_create_schedule
          flash[:success] = "La réservation a bien été prise en compte"
          redirect_to current_user
        else
          flash[:danger] = "La réservation n'a pas pu aboutir"
          redirect_back(fallback_location: root_path)
        end
      end
    else
      flash[:danger] = "Aucun créneau horaire ne correspond"
      redirect_back(fallback_location: root_path)

    end
  end 

  def destroy
    if @booking.future?
      Credit::Add.new(amount: @booking.price, user: @booking.student).call
      @booking.create_schedule_after_cancelling
      @booking.destroy
      respond_to do |format|
        format.html { redirect_to current_user, notice: "La réservation a bien été annulée" }
        format.json { head :no_content }
        format.js {}
      end
    else
      flash[:danger] = "Impossible de supprimer une réservation passée"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :duration)
  end
end
