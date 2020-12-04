class LessonsController < ApplicationController
  def index
    @lessons = Lesson.all
  end

  def show
    @lesson = Lesson.find(params[:id])
    @schedules = Schedule.where(user_id: @lesson.user.id).all
    @booking = Booking.new
  end

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = Lesson.new(lesson_params)
    @lesson.user_id = current_user.id
    if @lesson.save
        redirect_to @lesson
    else
      flash[:danger] = "Le cours n'a pas pu être créé"
      render :new
    end
  end

  def edit
    @lesson = Lesson.find(params[:id])
  end

  def update
    @lesson = Lesson.find(params[:id])
    if @lesson.update(lesson_params)
      redirect_to @lesson, success: "Le cours à été édité "
    else
      flash[:danger] = "Le cours n'as pas pu être édité"
      render :edit
    end
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :description, :picture)
  end
  
end
