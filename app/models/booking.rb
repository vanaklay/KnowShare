class Booking < ApplicationRecord
  validates :start_date, presence: true,
                         if: :start_in_future

  validates :duration, presence: true,
                       numericality: { only_integer: true, greater_than: 0 },
                       if: :multiple_of_thirty?

  belongs_to :user
  belongs_to :followed_lesson, foreign_key: 'followed_lesson_id', class_name: 'Lesson'

  validate :student_enough_credit?
  after_create :payment_from_student, :payment_to_teacher, :send_email_new_booking_user
  
  before_destroy :refund

  # Easier to read and use
  def student
    user
  end

  def teacher
    followed_lesson.user
  end

  # The number of credit to be transferred
  def price
    duration / 30
  end

  def lesson_title
    followed_lesson.title
  end

  def display_start_date
    start_date.strftime('%Y/%m/%d à %H:%M')
    
  end

  def student_enough_credit? 
      errors.add(:base, :student_personal_credit, message: 'Vous ne possédez pas suffisamment de crédit(s) !') unless user.personal_credit >= price
  end

  def not_begun?
    errors.add(:start_date, ": Impossible d'annuler un cours qui a déjà commencé.") unless start_date > DateTime.now
  end

  def refund
    if start_date > DateTime.now
      refund_from_teacher
      refund_to_student
    else
      errors.add(:start_date, ": Impossible d'annuler un cours qui a déjà commencé.")
      # Cancels the destroy action
      :abort
    end
  end

  private

  def start_in_future
    errors.add(:start_date, ": Impossible de réserver un événement dans le passé") unless start_date > DateTime.now
  end

  def multiple_of_thirty?
    errors.add(:duration, ": Les cours se font par tranche de 30min") unless (duration % 30).zero?
  end

  def payment_from_student
    student.remove_credit(price)
  end

  # Will change after finding out how to launch method at a certain date
  def payment_to_teacher
    teacher.add_credit(price)
  end

  # Will disappear after finding out how to launch method at a certain date : the credit won't be given until the lesson start
  def refund_from_teacher
    teacher.remove_credit(price)
  end

  def refund_to_student
    student.add_credit(price)
  end

  def send_email_new_booking_user
    UserMailer.send_email_confirm_to_user(self.student, self.teacher, self.display_start_date, self.lesson_title).deliver_now
  end

end
