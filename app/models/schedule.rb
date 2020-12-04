class Schedule < ApplicationRecord
  validates :start_time, uniqueness: { scope: :user_id, message: "Tu as déjà mis cet horaire" }

  belongs_to :user
end
