function Router(aUsers, aMatchmaking)
{
    MessageTypes = require('./message/messageTypes.js');

    var self = this;
    self.users = aUsers;
    self.matchmaking = aMatchmaking;
    self.messageTypes = new MessageTypes();

    self.handleMessage = function(aMessage)
    {
        switch(aMessage.type)
        {
            case self.messageTypes.messageLogin:

                var id = aMessage.data[0];
                var email = aMessage.data[1];
                var password = aMessage.data[2];

                self.users.login(id, email, password);

                break;

            case self.messageTypes.messageCreateUser:

                var id = aMessage.data[0];
                var userName = aMessage.data[1];
                var email = aMessage.data[2];
                var avatarId = aMessage.data[3];
                var password = aMessage.data[4];

                self.users.createUser(id, userName, email, avatarId, password);

                break;

            case self.messageTypes.messageFindMatch:

                var id = aMessage.data[0];

                self.matchmaking.findMatch(id);
        };
    };
};

module.exports = Router;