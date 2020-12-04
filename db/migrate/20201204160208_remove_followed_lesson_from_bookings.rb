class RemoveFollowedLessonFromBookings < ActiveRecord::Migration[5.2]
  change_table :bookings do |t|
    t.remove_belongs_to :followed_lesson, index: true
  end
end
