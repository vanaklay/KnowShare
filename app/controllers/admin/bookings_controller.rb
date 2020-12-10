require 'securerandom'

class Admin::BookingsController < ApplicationController
  include BookingsHelper
  before_action :authenticate_user!
  before_action :redirect_if_user_not_admin
  before_action :find_booking, only: [:destroy]
  before_action :all_bookings, only: [:index]
  
  def index
  end 
  
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to admin_bookings_path, notice: "La réservation a bien été annulée" }
      format.json { head :no_content }
      format.js {}
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :duration)
  end

  def all_bookings
    @bookings = Booking.all.sort
  end
end
