class LessonsController < ApplicationController
  before_action :authenticate_user!,        except: [:index, :show]
  before_action :find_lesson,               only: [:edit, :update, :destroy]
  before_action :redirect_if_not_author,    only: [:edit, :update, :destroy]
  before_action :all_lessons,               only: [:index]

  def index 
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
  end

  def update
    if @lesson.update(lesson_params)
      redirect_to @lesson, success: "Le cours a bien été édité"
    else
      flash[:danger] = "Le cours n'a pas pu être édité"
      render :edit
    end
  end

  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to lessons_path, success: "Le cours a bien été supprimé" }
      format.js { }
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

  def redirect_if_not_author
    unless current_user == @lesson.user
      redirect_to lessons_path, warning: "Tu n'es pas le créateur de cette leçon !"
    end
  end
end
