class Lesson < ApplicationRecord
  validates_presence_of :title, :description
  validates :title, uniqueness: { case_sensitive: false }, length: { minimum: 10 }
  validates :description, length: { in: 20...5000 }
  after_create :add_teacher_role, unless: :teacher_role?

  belongs_to :user
  has_many  :bookings
  has_many  :students,
            through: :bookings,
            foreign_key: 'student_id',
            class_name: 'User',
            dependent: :destroy
  has_one_attached :picture

  def teacher
    user
  end

  def teacher_role?
    user.teacher?
  end  
  
  def teacher?(user)
    user == teacher
  end
  
  private

  def add_teacher_role
    user.assign_teacher_role
  end
end
