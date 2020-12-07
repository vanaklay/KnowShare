class Schedule < ApplicationRecord
  validates :start_time, 
            uniqueness: { scope: :user_id, message: "Vous avez déjà créé ce début d'horaire !" }
  validates :start_time, presence: true, if: :start_in_future
  
  validates :end_time, presence: true, if: :end_must_be_after_start_time

  belongs_to :user

  def is_booked?
    self.title == "booked"
  end

  def start_must_be_outside_other_schedule(start_time, user_id)
    other_schedules = Schedule.where(user_id: user_id).all

    found = false
    other_schedules.each do |schedule|
      start_date = schedule.start_time
      end_date = schedule.end_time
      if start_time.between?(start_date, end_date) || end_time.between?(start_date, end_date)
        found = true
      end
    end
    return found
  end
  
  private

  def start_in_future
    errors.add(:start_time, ": Impossible de réserver un horaire dans le passé") unless start_time > DateTime.now
  end

  def end_must_be_after_start_time
    errors.add(:end_time, ": Impossible d'avoir un horaire de fin débutant avant l'horaire de début") unless end_time > start_time + 28.minute
  end

end
