function messageForm(){
  console.log("helloooo");
  var shiftDown = false;
  var chatroomForm = $("#new_message");
  var messageBox = chatroomForm.children("textarea");
  $(document).keypress(function (e) {
      if(e.keyCode == 13) {
          if(messageBox.is(":focus") && !shiftDown) {
           e.preventDefault(); // prevent another \n from being entered
      chatroomForm.submit();
      $(chatroomForm).trigger('reset');
          }
      }
  });
$(document).keydown(function (e) {
      if(e.keyCode == 16) shiftDown = true;
  });
$(document).keyup(function (e) {
      if(e.keyCode == 16) shiftDown = false;
  });
}