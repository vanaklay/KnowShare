module BookingsHelper
  def find_booking
    @booking = Booking.find(params[:id])
  end
end
