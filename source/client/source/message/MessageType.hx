package message;

class MessageType
{
    //To server
    static public inline var INIT_User:String                   = "InitUser";
    static public inline var LOGIN:String                       = "Login";
    static public inline var CREATE_USER:String                 = "CreateUser";
    static public inline var FIND_MATCH:String                  = "FindMatch";

    //From server
    static public inline var LOGGED_IN                          = "LoggedIn";
    static public inline var LOGIN_WRONG_PASSWORD               = "LoginWrongPassword";
    static public inline var LOGIN_USER_NOT_FOUND               = "LoginUserNotFound";
    static public inline var CREATE_EMAIL_TAKEN                 = "CreateEmailTaken";
    static public inline var USER_CREATED                       = "UserCreated";
    static public inline var ADD_USER                           = "AddUser";
    static public inline var REMOVE_USER                        = "RemoveUser";
    static public inline var SET_USER_ID                        = "SetUserId";
    static public inline var SELECT_USER                        = "SelectUser";
    static public inline var ADD_MATCHED_USER                   = "AddMatchedUser";
    static public inline var JOIN_GAME                          = "JoinGame";
}