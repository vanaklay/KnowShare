class SchedulesController < ApplicationController
  before_action :find_user

  def index
    @schedules = Schedule.where(user_id: params[:user_id]).all.order("start_time")
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.user_id = current_user.id
    if @schedule.save
      respond_to do |format|
        format.html { redirect_to user_schedules_path }
        format.js { }
      end
    else
      flash.now[:danger] = "L'horaire n'a pas pu être créé"
      render :index
    end
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def schedule_params
    params.require(:schedule).permit(:start_time, :end_time)
  end

end
