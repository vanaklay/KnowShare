module BookingsHelper
  def find_booking
    @booking = Booking.find(params[:id])
  end

  def teacher?
    current_user == @booking.teacher
  end

  def prevent_teacher_booking
    if teacher?
      flash[:danger] = 'Vous ne pouvez pas réserver une séance avec vous-même !'
      redirect_back(fallback_location: root_path)
    end
  end
end
