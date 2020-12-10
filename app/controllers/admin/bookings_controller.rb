require 'securerandom'

class Admin::BookingsController < Admin::FacadeController
  include BookingsHelper
  before_action :find_booking, only: [:destroy]
  
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
end
