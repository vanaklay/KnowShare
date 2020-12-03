class LessonsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = Lesson.new(lesson_params)
    @lesson.user_id = current_user.id
    if @lesson.save
        redirect_to root_path
    else
      flash[:danger] = "Le cours n'a pas pu être créé"
      render :new
    end
  end

  def update
    
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :description, :picture)
    
  end



end
