class ChangeDefaultValuePersonalCredit < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :personal_credit, 4
  end
end
