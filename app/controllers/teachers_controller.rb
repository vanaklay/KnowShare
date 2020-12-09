class TeachersController < ApplicationController

  def show
    @user = Lesson.find(params[:id]).user
    @lessons = @user.lessons
  end
  
end
