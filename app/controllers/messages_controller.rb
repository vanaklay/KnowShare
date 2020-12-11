class MessagesController < ApplicationController
  
  def create
    message = Message.new(message_params)
    message.user = current_user
    if message.save
      #broadcasting out to messages channel including the chat_id so messages are broadcasted to specific chat only
      ActionCable.server.broadcast( "messages_#{message_params[:chatroom_id]}",
      #message and user hold the data we render on the page using javascript 
      message: message.content,
      user: message.user, 
      booking: message.chatroom.booking.user,
      username: message.user.username
      )
    else
      redirect_to root_path
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :chatroom_id)
  end
  
end