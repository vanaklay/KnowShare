class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.datetime :start_date, null: false
      t.integer :duration,    null: false

      t.belongs_to :user, index: true
      
      t.timestamps
    end
  end
end
