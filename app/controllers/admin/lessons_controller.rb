class Admin::LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_user_not_admin
  before_action :all_lessons, only: [:index]
  before_action :find_lesson, only: [:show, :destroy]

  def index
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def show
    @lesson = Lesson.find(params[:id])
    @schedules = Schedule.where(user_id: @lesson.user.id).all.order("start_time")
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

  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to admin_lessons_path, notice: "Le cours a bien été supprimé" }
      format.json { head :no_content }
      format.js {}
    end
  end 

  private

  def lesson_params
    params.require(:lesson).permit(:title, :description, :picture)
  end

  def all_lessons
    @lessons = Lesson.all.sort.reverse
  end

  def find_lesson
    @lesson = Lesson.find(params[:id])
  end
  
end
