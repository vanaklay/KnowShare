module BookingsHelper
  def find_booking
    @booking = Booking.find(params[:id])
  end

  def teacher?
    current_user == @booking.teacher
  end

  def prevent_teacher_booking
    flash[:danger] = 'Vous ne pouvez pas réserver une séance avec vous-même !'
    redirect_back(fallback_location: root_path)
  end

  def create_booking
    if teacher?
      prevent_teacher_booking
    else
      if @booking.save
        flash[:success] = "Votre réservation a bien été prise en compte"
        redirect_to(user_path(current_user))
      else
        flash[:danger] = "Votre réservation n'a pas pu aboutir"
        redirect_back(fallback_location: root_path)
      end
    end
  end

end
