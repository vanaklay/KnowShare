class Lesson < ApplicationRecord

  validates_presence_of :title, :description, :number_of_credit
  validates :title, uniqueness: { case_sensitive: false }
  validates :description, length: { in: 20...5000 }
  validates :number_of_credit, numericality: { grater_than_or_equal_to: 1 }

  has_one_attached :picture
  
end
