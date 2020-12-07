class SchedulesController < ApplicationController
  before_action :find_user

  def index
    @schedules = Schedule.where(user_id: params[:user_id]).all.order("start_time")
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.user_id = current_user.id
    if @schedule.start_must_be_outside_other_schedule(@schedule.start_time, @schedule.user_id)
      flash[:danger] = "Tu ne peux pas créer d'horaire dans une plage horaire existante"
      redirect_to user_schedules_path
    else 
      if @schedule.save
        flash[:success] = "Horaire créé avec succès"
        redirect_to user_schedules_path
      else
        flash[:danger] = "L'horaire n'a pas pu être créé"
        redirect_to user_schedules_path
      end
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
