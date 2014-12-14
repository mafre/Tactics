function User(socket)
{
    Message = require('../message/message.js');

    var self = this;
    self.socket = socket;
    self.id = socket.id;
    self.ready = false;
    self.userName = socket.id;
    self.email = "";
    self.avatarId = 0;

    self.sendMessage = function(aType, aData)
    {
        var message = new Message(aType, aData);
        socket.emit("ServerMessage", message);
    };
}

module.exports = User;