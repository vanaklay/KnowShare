class ChatroomsController < ApplicationController

  before_action :authenticate_user!

  def index
    chatrooms = current_user.chatrooms
    @existing_chatrooms_users = current_user.existing_chatrooms_users
  end

  def create
    @chatroom = Chatroom.find(params[:id])
    @related_booking = @chatroom.booking_id
    @other_user = @related_booking.teacher
    # @chatroom.subscriptions.create(user_id: current_user.id)
    # @chatroom.subscriptions.create(user_id: @other_user.id)
  end

  def show
    # @other_user = User.find(params[:other_user])
    @chatroom = Chatroom.find_by(id: params[:id])
    # @message = Message.new
  end
  
  private

  def find_chatroom(second_user)
    chatrooms = current_user.chatrooms
    chatrooms.each do |chatroom|
      chatroom.subscriptions.each do |s|
        if s.user_id == second_user.id
          return chatroom
        end
      end
    end
    nil
  end

end