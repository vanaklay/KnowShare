class Booking < ApplicationRecord
  validates :start_date, presence: true,
                         if: :start_in_future

  validates :duration, presence: true,
                       numericality: { only_integer: true, greater_than: 0 },
                       if: :multiple_of_thirty?

  belongs_to :user
  belongs_to :lesson

  has_one :chatroom, dependent: :destroy

  validate :student_enough_credit?, :prevent_teacher_booking

  # ------- Easier to read and use ------- #

  def student
    user
  end

  def teacher
    lesson.user
  end

  # The number of credit to be transferred
  def price
    duration / 30
  end

  def lesson_title
    lesson.title
  end
  
  def display_start_date
    start_date.strftime('%Y/%m/%d à %H:%M')    
  end

  def display_start_date_time
    start_date.strftime("%d/%m/%Y à %H:%M")
  end 
  
  def student_is_teacher?
    user == teacher
  end

  def future?
    start_date > DateTime.now
  end

  def paid?
    paid
  end

  def start_must_be_in_schedule
    all_schedules = Schedule.where(user_id: self.lesson.user_id).all

    found = false
    all_schedules.each do |schedule|
      start_date_schedule = schedule.start_time
      end_date_schedule = schedule.end_time
      if start_date.between?(start_date_schedule, end_date_schedule) && end_date.between?(start_date_schedule, end_date_schedule) && !schedule.is_booked?
        found = true
      end
    end
    return found
  end

  def split_and_create_schedule
    schedule = Schedule.where('start_time <= ? AND end_time >= ?', self.start_date, end_date)[0]
    start_time_from_schedule = start_time(schedule) 
    end_time_from_schedule = end_time(schedule)
    user = User.find(self.lesson.user_id)

    if schedule.start_time == self.start_date && end_date == end_time_from_schedule
      schedule.update(title: "booked")

    elsif schedule.start_time < self.start_date 
      schedule.destroy
      if start_time_from_schedule < DateTime.now && self.start_date > (DateTime.now + 0.5/24)
        if end_date != end_time_from_schedule
          Schedule.create(start_time: start_time_now, end_time: self.start_date, user: user)
          Schedule.create(title: "booked", start_time: self.start_date, end_time: end_date, user: user)
          Schedule.create(start_time: end_date, end_time: end_time_from_schedule, user: user)
        else
          Schedule.create(start_time: start_time_now, end_time: self.start_date, user: user)
          Schedule.create(title: "booked", start_time: self.start_date, end_time: end_time_from_schedule, user: user)
        end
      elsif end_date == end_time_from_schedule
        Schedule.create(start_time: start_time_from_schedule, end_time: self.start_date, user: user)
        Schedule.create(title: "booked", start_time: self.start_date, end_time: end_time_from_schedule, user: user)
      else
        Schedule.create(start_time: start_time_from_schedule, end_time: self.start_date, user: user)
        Schedule.create(title: "booked", start_time: self.start_date, end_time: end_date, user: user)
        Schedule.create(start_time: end_date, end_time: end_time_from_schedule, user: user)

      end
    elsif schedule.start_time == self.start_date
      schedule.destroy
      Schedule.create(title: "booked", start_time: self.start_date, end_time: end_date, user: user) 
      Schedule.create(start_time: end_date, end_time: end_time_from_schedule, user: user)
    end
  end

  def create_schedule_after_cancelling
    user = User.find(self.lesson.user_id)
    all_schedules = Schedule.where(user_id: self.lesson.user_id).all.order("start_time")
    self_schedule = Schedule.where('start_time <= ? AND end_time >= ?', self.start_date, end_date)[0]
    found = all_schedules.select { |schedule| (self.start_date == schedule.end_time && !schedule.is_booked?) || (end_date == schedule.start_time && !schedule.is_booked?) }
    if found.length > 0
      if found.length > 1
        start_of_schedule = found[0].start_time
        end_of_schedule = found[1].end_time
        found[1].destroy
        found[0].destroy
        self_schedule.destroy
        if start_of_schedule < DateTime.now && self.start_date > (DateTime.now + 0.5/24)
          Schedule.create(start_time: start_time_now, end_time: end_of_schedule, user: user)
        else
          Schedule.create(start_time: start_of_schedule, end_time: end_of_schedule, user: user)
        end
      elsif found[0].end_time == self.start_date
        start_of_schedule = found[0].start_time
        found[0].destroy
        self_schedule.destroy
        if start_of_schedule < DateTime.now && self.start_date > (DateTime.now + 0.5/24)
          Schedule.create(start_time: start_time_now, end_time: end_date, user: user)
        else
          Schedule.create(start_time: start_of_schedule, end_time: end_date, user: user)
        end
      elsif found[0]
        end_of_schedule = found[0].end_time
        found[0].destroy
        self_schedule.destroy
        Schedule.create(start_time: self.start_date, end_time: end_of_schedule, user: user)
      else 
        return
      end
    else
      self_schedule.destroy
      Schedule.create(start_time: self.start_date, end_time: end_date, user: user)
    end
  end
  
  private
  
  # ------- Validation methods ------- #

  def prevent_teacher_booking
    errors.add(:base, :student_is_teacher, message: 'Vous ne pouvez pas réserver une séance avec vous-même !') if student_is_teacher?
  end

  def student_enough_credit?
    errors.add(:base, :student_personal_credit, message: 'Vous ne possédez pas suffisamment de crédit(s) !') unless user.personal_credit >= price
  end

  def not_begun?
    errors.add(:start_date, ": Impossible d'annuler un cours qui a déjà commencé.") unless start_date > DateTime.now
  end

  def start_in_future
    errors.add(:start_date, ": Impossible de réserver une leçon dans le passé") unless start_date > DateTime.now
  end

  def multiple_of_thirty?
    errors.add(:duration, ": Les cours se font par tranche de 30min") unless (duration % 30).zero?
  end

  def end_date
    self.start_date + self.duration.minute
  end

  def start_time(schedule)
    schedule.start_time
  end

  def end_time(schedule)
    schedule.end_time
  end

  def start_time_now
    day_start = Date.today
    if DateTime.now.minute < 30 
      day_start = day_start + (DateTime.now.hour.hour) + 30.minute 
      day_start
    else
      day_start = day_start + (DateTime.now.hour.hour) + 1.hour 
      day_start
    end
  end
end
