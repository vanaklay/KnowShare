class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.datetime :start_date, null: false
      t.integer :duration,    null: false, default: 30

      t.belongs_to :student, index: true
      t.belongs_to :followed_lesson, index: true

      t.timestamps
    end
  end
end
