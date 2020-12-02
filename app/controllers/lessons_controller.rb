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
    @lesson.user_id = current_user
    if @lesson.save
      respond_to do |format|
        format.html { redirect_to lesson(@lesson.id), notice: "Cours créé avec succès !" }
        format.js { }
      end
    else
      flash[:danger] = "Le cours n'a pas pu être créé"
      render :new
    end
  end

  def update
    
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :description, :number_of_credit, :picture)
    
  end



end
