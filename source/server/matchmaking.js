function Matchmaking(aUsers)
{
    MessageTypes = require('./message/messageTypes.js');

    var self = this;
    self.users = aUsers;
    self.messageTypes = new MessageTypes();
    self.usersToMatch = [];
    self.maxPlayerCount = 2;

    self.findMatch = function(aId)
    {
        var aUser = self.users.getUserById(aId);

        if(aUser)
        {
            var aUsers = [aUser];

            for (var i = 0; i < self.usersToMatch.length; i++)
            {
                aUsers.push(self.usersToMatch[i]);

                if(aUsers.length == self.maxPlayerCount)
                {
                    self.foundMatch(aUsers);
                    return;
                }
            };

            self.usersToMatch.push(aUser);
        };
    };

    self.foundMatch = function(aUsers)
    {
        for (var i = 0; i < aUsers.length; i++)
        {
            var aUser = aUsers[i];

            for (var j = 0; j < aUsers.length; j++)
            {
                var aMatchedUser = aUsers[j];

                if(aUser.id != aMatchedUser.id)
                {
                    var data = {};
                    data["id"] = aMatchedUser.id;
                    data["userName"] = aMatchedUser.userName;
                    data["avatarId"] = aMatchedUser.avatarId;

                    aUser.sendMessage(self.messageTypes.messageAddMatchedUser, data);
                };
            };
        };

        for (var i = 0; i < aUsers.length; i++)
        {
            aUsers[i].sendMessage(self.messageTypes.messageJoinGame, {});
        };

        for (var i = aUsers.length-1; i >= 0; i--)
        {
            self.removeUser(aUsers[i]);
        };
    };

    self.removeUser = function(aId)
    {
        var userIndex = -1;

        for(var i = 0; i < self.usersToMatch.length; i++)
        {
            if(self.usersToMatch[i].id == aId)
            {
                userIndex = i;
                break;
            };
        };

        if(userIndex == -1)
        {
            return;
        };

        self.usersToMatch.splice(userIndex, 1);
    };
}

module.exports = Matchmaking;