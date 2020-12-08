class CreateChatrooms < ActiveRecord::Migration[5.2]
  def change
    create_table :chatrooms do |t|
      t.string :identifier
      t.belongs_to :booking, index: true

      t.timestamps
    end
  end
end
