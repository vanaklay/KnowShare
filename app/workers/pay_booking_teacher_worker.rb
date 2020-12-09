# frozen_string_literal: true

class PayBookingTeacherWorker
  include Sidekiq::Worker

  def perform
    bookings_to_pay = Booking.all.sort.select { |booking| (booking.paid? == false && booking.future? == false) }
    bookings_to_pay.each do |booking_to_pay|
      Credit::Add.new(amount: booking_to_pay.price, user: booking_to_pay.teacher).call
      booking_to_pay.update_attribute(:paid, true)
    end
  end
end
