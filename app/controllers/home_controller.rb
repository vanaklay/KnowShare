class HomeController < ApplicationController
  before_action :all_lessons, only: [:index]

  def index
    @lessons = Lesson.all.sample(6) if @lessons.length > 6
  
  end

  private

  def all_lessons
    @lessons = Lesson.all.sort

  end
  
end
