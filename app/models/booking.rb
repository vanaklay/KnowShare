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
  after_create :send_email_new_booking_user, :send_email_new_booking_teacher
  
  before_destroy :destroy_booking

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
      if start_date.between?(start_date_schedule, end_date_schedule) && end_date.between?(start_date_schedule, end_date_schedule)
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

    if schedule.start_time != self.start_date 
      schedule.destroy
      Schedule.create(start_time: start_time_from_schedule, end_time: self.start_date, user: user)
      if end_date != end_time_from_schedule
        Schedule.create(start_time: end_date, end_time: end_time_from_schedule, user: user)
      end

    elsif schedule.start_time == self.start_date 
      schedule.destroy
      Schedule.create(start_time: end_date, end_time: end_time_from_schedule, user: user)

    elsif schedule.start_time == self.start_date && end_date == end_time_from_schedule
      schedule.destroy
    end

  end

  def create_schedule_after_cancelling
    user = User.find(self.lesson.user_id)
    Schedule.create(start_time: self.start_date, end_time: end_date, user: user)
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

  def destroy_booking
    if start_date > DateTime.now
      after_destroy_booking_email
    else
      errors.add(:start_date, ": Impossible d'annuler un cours qui a déjà commencé.")
      # Cancels the destroy action
      :abort
    end
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

  # -------- Email section -------- #

  def send_email_new_booking_user
    BookingMailer.send_email_confirm_to_user(self.student, self.teacher, self.display_start_date, self.lesson_title).deliver_now
  end

  def send_email_new_booking_teacher
    BookingMailer.send_email_confirm_to_teacher(self.student, self.teacher, self.display_start_date, self.lesson_title).deliver_now
  end

  def after_destroy_booking_email
    BookingMailer.after_destroy_booking_email(self.teacher, self.display_start_date, self.lesson_title).deliver_now
    BookingMailer.after_destroy_booking_email(self.student, self.display_start_date, self.lesson_title).deliver_now # Not DRY, but it works
  end

end
