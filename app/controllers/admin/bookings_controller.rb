require 'securerandom'

class Admin::BookingsController < Admin::FacadeController
  include BookingsHelper
  before_action :find_booking, only: [:destroy]
  
  def index
  end 
  
  def destroy
    if @booking.future?
      Credit::Add.new(amount: @booking.price, user: @booking.student).call
      BookingMailer.send_cancel_booking_email_to_student(booking: @booking).deliver_now
      BookingMailer.send_cancel_booking_email_to_teacher(booking: @booking).deliver_now
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
