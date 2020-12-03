class Lesson < ApplicationRecord
  validates_presence_of :title, :description
  validates :title, uniqueness: { case_sensitive: false }, length: { minimum: 10 }
  validates :description, length: { in: 20...5000 }
  after_create :add_teacher_role, if: :not_teacher?

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

  private

  def not_teacher?
    user.teacher? ? false : true
  end

  def add_teacher_role
    user.assign_teacher_role
  end
end
