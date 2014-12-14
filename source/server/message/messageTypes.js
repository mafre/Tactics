function MessageTypes()
{
    var self = this;

    // From client
    self.messageLogin                   = "Login";
    self.messageCreateUser              = "CreateUser";
    self.messageFindMatch               = "FindMatch";

    // To client
    self.messageLoggedIn                = "LoggedIn";
    self.messageLoginWrongPassword      = "LoginWrongPassword";
    self.messageLoginUserNotFound       = "LoginUserNotFound";
    self.messageCreateEmailTaken        = "CreateEmailTaken";
    self.messageUserCreated             = "UserCreated";
    self.messageRemoveUser              = "RemoveUser";
    self.messageSetUserId               = "SetUserId";
    self.messageAddMatchedUser          = "AddMatchedUser";
    self.messageJoinGame                = "JoinGame";
};

module.exports = MessageTypes;