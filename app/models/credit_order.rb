class CreditOrder < ApplicationRecord
  belongs_to :user

  validates :number_of_credit,
             presence: true,
             numericality: { grater_than_or_equal_to: 1 }
  validates :price,
             presence: true,
             numericality: { grater_than_or_equal_to: 1 }


end
