class Schedule < ApplicationRecord
  validates :start_time, uniqueness: { scope: :user_id, message: "Tu as déjà mis cet horaire" }

  validates :start_time, presence: true, if: :start_in_future

  belongs_to :user

  def is_booked?
    self.title == "booked"
  end
  
  private

  def start_in_future
    errors.add(:start_time, ": Impossible de réserver un horaire dans le passé") unless start_time > DateTime.now
  end

  
end
