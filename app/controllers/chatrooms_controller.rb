class ChatroomsController < ApplicationController

  before_action :authenticate_user!
  before_action :chatroom_users, only: [:show]

  def create
    @chatroom = Chatroom.find(params[:id])
    @related_booking = @chatroom.booking_id
    @chatroom.subscriptions.create(user_id: @related_booking.teacher.id)
    @chatroom.subscriptions.create(user_id: @related_booking.student.id)
  end

  def show
    @chatroom = Chatroom.find_by(id: params[:id])
    @message = Message.new
  end

  private

  def chatroom_users
    @chatroom = Chatroom.find(params[:id])
    @related_booking = @chatroom.booking
    redirect_to root_path, danger: "Impossible d'accéder à cette page" unless current_user == @related_booking.teacher || current_user == @related_booking.student
  
  end


end