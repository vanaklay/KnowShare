class CreateCreditOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :credit_orders do |t|
      t.integer :number_of_credit, null: false
      t.decimal :price,            null: false

      t.belongs_to :user, index: true
      
      t.timestamps
    end
  end
end
