class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username,  presence: true,
                        uniqueness: true

  has_many  :lessons, dependent: :destroy
  has_many  :bookings, dependent: :destroy
  has_many  :followed_lessons,
            through: :bookings,
            foreign_key: 'followed_lesson_id',
            source: :lesson,
            dependent: :destroy
  has_many :messages
  has_many :chatrooms, through: :bookings, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :credit_orders, dependent: :destroy

  has_one_attached :avatar

  def role?
    role.instance_of?(String)
  end

  after_create :send_welcome_email

  def role_include?(searched_role)
    role.split.include?(searched_role) if role?
  end

  def teacher?
    role_include?('teacher')
  end

  def assign_teacher_role
    new_role = 'teacher'
    update(role: new_role)
  end

  def first_name?
    first_name
  end

  def display_first_name
    if first_name?
      first_name
    else
      'Pas encore de prénom !'
    end
  end

  def last_name?
    last_name
  end

  def display_last_name
    if last_name?
      last_name
    else
      'Pas encore de nom !'
    end
  end

  def display_name
    if first_name?
      if last_name?
        "#{first_name} #{last_name}"
      else
        first_name
      end
    else
      username
    end
  end

  def display_avatar
    if avatar.attached?
      avatar
    else
      # url to picture of cute cat
      'https://static.toiimg.com/photo/msid-67586673/67586673.jpg?3918697'
    end
  end

  def description?
    description
  end

  def display_description
    if description?
      description
    else
      'Pas encore de bio, édite vite ton profil pour en rajouter une !'
    end
  end

  def students
    students = []
    lessons.each do |lesson|
      lesson.students.each { |student| students << student }
    end
    students
  end

  def send_welcome_email
    UserMailer.welcome_send(self).deliver_now
  end

  def not_admin
    self.is_admin = false
  end

  def is_admin?
    self.is_admin == true
  end

  def past_student_bookings
    @past_student_bookings = bookings.select { |booking| booking.start_date < DateTime.now }
  end

  def future_student_bookings
    @future_student_bookings = bookings.select { |booking| booking.start_date > DateTime.now }
  end

  def teacher_bookings
    teacher_bookings = []
    lessons.each do |lesson|
      lesson.bookings.each { |booking| teacher_bookings << booking }
    end
  end

  def past_teacher_bookings
    teacher_bookings.select { |booking| booking.start_date < DateTime.now }
  end

  def future_teacher_bookings
    teacher_bookings.select { |booking| booking.start_date > DateTime.now }
  end

  def has_schedules?
    self.schedules.length > 0
  end

end
