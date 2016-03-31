// file: app/assets/javascript/socket_chat.js
// please type it yourself, do NOT copy & paste

var ws_protocol = window.location.protocol === 'http:' ? 'ws:' : 'wss:'
window.ws = new WebSocket(ws_protocol + '//' + window.document.location.host)

ws.onmessage = function(rawMessage) {
  var message = JSON.parse(rawMessage.data);
  $(".messages").append($('<div />').html(message.user.email + ': ' + message.content));
};

function setupForm() {
  $("form#new_message").on("submit", function(event) {
    event.preventDefault();
    var content = $("#message_content").val();
    var user    = window.currentUser;
    // let's use JSON to convert an object into string
    ws.send(JSON.stringify({ content: content, user: user }));
    // clear the input text:
    $("#message_content").val('')
  });
}

// use page:change to be compatible with turbolinks
$(document).on("page:change", function(){
  setupForm();
});
