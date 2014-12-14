function Matchmaking(aUsers)
{
    MessageTypes = require('./message/messageTypes.js');

    var self = this;
    self.users = aUsers;
    self.usersToMatch = [];
    self.maxPlayerCount = 2;

    self.userIsLookingForGames = function(aId)
    {
        var aUser = self.users.getUserById(aId);

        if(aUser)
        {
            self.usersToMatch.push(aUser);
            self.findMatch(aUser)
        };
    }

    self.findMatch = function(aUser)
    {
        var aUsers = [aUser];

        for (var i = 0; i < self.usersToMatch.length; i++)
        {
            if(self.usersToMatch[i].id != aUser.id)
            {
                aUsers.push(self.usersToMatch[i]);

                if(aUsers.length == self.maxPlayerCount)
                {
                    self.foundMatch(aUsers);
                    return;
                }
            }
        };
    }

    self.foundMatch = function(aUsers)
    {
        for (var i = 0; i < aUsers.length; i++)
        {
            var data = {};
            data["id"] = aId;
            self.users[i].sendMessage(self.messageTypes.messageRemoveUser, data);
        };
    }

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

module.exports = User;