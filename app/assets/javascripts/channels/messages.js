function createMessageChannel() {
  App.messages = App.cable.subscriptions.create({
        channel: 'MessagesChannel', chatroom_id: parseInt($("#message_chatroom_id").val())
        },
        {
        received: function(data) {
          $("#messages").removeClass('hidden')
          return $('#messages').append(this.renderMessage(data));
        },
        renderMessage: function(data) {
    return "<p class='bg-info p-2 ml-auto' id='message'> <b>" + data.user + ": </b>" + data.message + "</p>";
  },
      });
return App.messages;
}