require 'securerandom'

class ChatroomsController < ApplicationController

  before_action :authenticate_user!

  def index
    
  end

  def create
    @other_user = User.find(params[:other_user])
    @chatroom = find_chatroom(@other_user) || Chatroom.new(identifier: SecureRandom.hex)
    if !@chatroom.persisted?
      @chatroom.save
      @chatroom.subscriptions.create(user_id: current_user.id)
      @chatroom.subscriptions.create(user_id: @other_user.id)
    end
    redirect_to user_chatroom_path(current_user, @chatroom,  :other_user => @other_user.id) 
  end

  def show
    @other_user = User.find(params[:other_user])
    @chatroom = Chatroom.find_by(id: params[:id])
    @message = Message.new
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