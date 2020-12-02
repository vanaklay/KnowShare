class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username,  presence: true,
                        uniqueness: true

  has_many :bookings
  has_many :followed_lessons, 
            through: :bookings, 
            foreign_key: "followed_lesson_id", 
            class_name: "Lesson", 
            dependent: :destroy

  
  has_one_attached :avatar

end
