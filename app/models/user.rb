class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username,          presence: true,
                                uniqueness: true,
                                format: { with: /\A[a-zA-Z0-9 ]*\z/ ,
                                          message: ': seuls les lettres et les chiffres sont acceptés'
                                        }

  validates :first_name,        format: { with: /\A[a-zA-Z0-9 ]*\z/ ,
                                          message: 'Prénom : Seuls les lettres et les chiffres sont acceptés'
                                        }

  validates :last_name,         format: { with: /\A[a-zA-Z0-9 ]*\z/ ,
                                          message: 'Nom : Seuls les lettres et les chiffres sont acceptés'
                                        }

  has_many  :lessons,           dependent: :destroy
  has_many  :bookings,          dependent: :destroy
  has_many  :followed_lessons,  through: :bookings,
                                foreign_key: 'followed_lesson_id',
                                source: :lesson,
                                dependent: :destroy
  has_many :messages
  has_many :chatrooms,          through: :bookings, 
                                dependent: :destroy
  has_many :schedules,          dependent: :destroy
  has_many :credit_orders,      dependent: :destroy

  has_one_attached :avatar

  before_save :capitalize_first_name, :capitalize_last_name

  # To display user's username in the url instead of its id
  def to_param
    username
  end

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
    first_name.nil? || first_name.split.count.zero? ? false : true
  end

  def display_first_name
    first_name? ? first_name : 'Pas encore de prénom !'
  end

  def capitalize_first_name
    self.first_name = self.first_name.capitalize if self.first_name?
  end

  def last_name?
    last_name.nil? || last_name.split.count.zero? ? false : true
  end

  def display_last_name
    last_name? ? last_name : 'Pas encore de nom !'
  end
  
  def capitalize_last_name
    self.last_name = self.last_name.capitalize if self.last_name?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def display_name
    if first_name? && last_name?
      full_name
    elsif first_name?
      first_name
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
    description.nil? || description.split.count.zero? ? false : true
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
    teacher_bookings
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

  def subscription_date
    created_at.strftime("%d/%m/%Y")
  end 
end
