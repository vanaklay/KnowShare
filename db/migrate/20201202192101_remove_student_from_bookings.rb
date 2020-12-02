class RemoveStudentFromBookings < ActiveRecord::Migration[5.2]
  def change
    change_table :bookings do |t|
      t.remove_belongs_to :student, index: true
    end
  end
end
