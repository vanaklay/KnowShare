class CreditOrder < ApplicationRecord
  belongs_to :user

  validates :number_of_credit,
             presence: true,
             numericality: { greater_than_or_equal_to: 1 }
  validates :price,
             presence: true,
             numericality: { greater_than_or_equal_to: 1 }

  def display_start_date_time
    created_at.strftime("%d/%m/%Y à %H:%M")
  end 

end
