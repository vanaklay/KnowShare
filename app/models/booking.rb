class Booking < ApplicationRecord
  validates :start_date, presence: true, if: :start_in_future
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }, if: :multiple_of_thirty?

  belongs_to :student, foreign_key: "student_id", class_name: "User"


  def start_in_future
    errors.add(:start_date, ": Impossible de réserver un événement dans le passé") unless start_date > DateTime.now
  end

  def multiple_of_thirty?
    errors.add(:duration, ": Les cours se font par tranche de 30min") unless duration % 30 == 0
    
  end

  private

  def teacher
    user
    
  end
  
end
