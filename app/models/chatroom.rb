class Chatroom < ApplicationRecord

  belongs_to :booking
  has_many :messages, dependent: :destroy
  has_many :users, through: :bookings

  validates :identifier, presence: true, uniqueness: true, case_sensitive: false
end
