desc "After a booking's start date passed, send the amount of credits to the teacher of the booking"
task pay_booking_teacher: :environment do
  puts "*" * 80
  puts 'start of the pay_booking_teacher task'
  count = 0
  bookings_to_pay = Booking.all.sort.select { |booking| (booking.paid? == false && booking.future? == false) }
  bookings_to_pay.each do |booking_to_pay|
    Credit::Add.new(amount: booking_to_pay.price, user: booking_to_pay.teacher).call
    booking_to_pay.update_attribute(:paid, true)
    count += 1
  end
  puts "Number of started bookings : #{count}"
  puts "end of the pay_booking_teacher task"
  puts "*" * 80
end
