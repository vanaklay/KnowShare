class AddPersonalCreditToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :personal_credit, :integer
  end
end
