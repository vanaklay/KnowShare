class CreateLessons < ActiveRecord::Migration[5.2]
  def change
    create_table :lessons do |t|
      t.string :title,             null: false
      t.text :description,         null: false
      t.integer :number_of_credit, null: false

      t.timestamps
    end
  end
end
