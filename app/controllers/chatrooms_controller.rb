class ChatroomsController < ApplicationController

  before_action :authenticate_user!

  def index
    chatrooms = current_user.chatrooms
    @existing_chatrooms_users = current_user.existing_chatrooms_users
  end

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
  

end