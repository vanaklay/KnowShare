class AddLessonToBookings < ActiveRecord::Migration[5.2]
  def change
    add_reference :bookings, :lesson, foreign_key: true
  end
end
