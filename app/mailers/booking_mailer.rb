class BookingMailer < ApplicationMailer

  def send_email_confirm_to_user(student, teacher, start_date, lesson_title)
    @student = student 
    @teacher = teacher
    @start_date = start_date
    @lesson_title = lesson_title
    mail(to: @student.email, subject: 'Votre nouvelle réservation !') 
  end

  def send_email_confirm_to_teacher(student, teacher, start_date, lesson_title)
    @student = student 
    @teacher = teacher
    @start_date = start_date
    @lesson_title = lesson_title
    mail(to: @teacher.email, subject: 'Une nouvelle réservation de cours !') 
  end

  def send_cancel_booking_email_to_student(booking:)
    @user = booking.student
    @start_date = booking.display_start_date_time
    @lesson_title = booking.lesson_title
    @credits = booking.price
    mail(to: @user.email, subject: "Information concernant l'annulation du cours")
  end

  def send_cancel_booking_email_to_teacher(booking:)
    @user = booking.teacher
    @start_date = booking.display_start_date_time
    @lesson_title = booking.lesson_title
    mail(to: @user.email, subject: "Information concernant l'annulation du cours")
  end
end
