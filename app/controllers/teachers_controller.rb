class TeachersController < ApplicationController

  def show
    @user = Lesson.find(params[:lesson_id]).user
    @lessons = @user.lessons
  end
  
end
