package user;

import flash.display.Sprite;
import flash.geom.Point;
import flash.display.MovieClip;
import flash.utils.Object;
import flash.events.Event;
import flash.events.EventDispatcher;

import event.DataEvent;
import event.EventType;
import event.EventBus;
import common.StageInfo;
import message.Message;
import message.MessageType;
import state.StateHandler;
import haxe.ds.StringMap;
import connection.ConnectionHandler;
import utils.PositionHelper;
import character.CharacterHandler;

import user.User;

class UserHandler
{
	static private var __instance:UserHandler;
	static public var dispatcher:EventDispatcher;

	public var userId:String;
    public var myUser:User;
	public var matchedUsers:Array<User>;
    public var currentUserIndex:Int;

	public function new()
	{
        EventBus.subscribe(EventTypes.EndTurn, endTurn);
        EventBus.subscribe(EventTypes.NextTurn, nextTurn);
	};

	public function init():Void
	{
		dispatcher = new EventDispatcher();
		matchedUsers = new Array<User>();
	};

    public function endTurn():Void
    {
        CharacterHandler.getInstance().disableUser(getCurrentUser().id);

        currentUserIndex++;

        if(currentUserIndex == getUserOrder().length)
        {
            currentUserIndex = 0;
        }

        EventBus.dispatch(EventTypes.ShowNextUser, getCurrentUser().id);
    }

    public function nextTurn():Void
    {
        CharacterHandler.getInstance().enableUser(getCurrentUser().id);
        CharacterHandler.getInstance().resetUsersCharacters(getCurrentUser().id);
    }

    public function getCurrentUser():User
    {
        var sortedUsers:Array<User> = getUserOrder();
        return sortedUsers[currentUserIndex];
    }

	public function setUserId(aId:String):Void
	{
		userId = aId;
	};

    public function setMyUser(aId:String, aName:String, aPlayOrder:Int):Void
    {
        myUser = new User(aId, aName, aPlayOrder);
    }

	public function addMatchedUser(aId:String, aName:String, aPlayOrder:Int):Void
	{
		var user:User = new User(aId, aName, aPlayOrder);
		matchedUsers.push(user);
	};

    public function getUserOrder():Array<User>
    {
        var sortedUsers:Array<User> = [];

        for (matchedUser in matchedUsers)
        {
            sortedUsers.push(matchedUser);
        }

        sortedUsers.push(myUser);

        sortedUsers.sort( function(a:User, b:User):Int
        {
            if (a.playOrder < b.playOrder) return -1;
            if (a.playOrder > b.playOrder) return 1;
            return 0;
        });

        return sortedUsers;
    }

	public function removeUser(aId:String):Void
	{
		var user = getUser(aId);

		if(user == null)
		{
			return;
		};

		matchedUsers.remove(user);
	};

	public function getUser(aId:String):User
	{
		for (i in 0...matchedUsers.length)
		{
			var aUser:User = matchedUsers[i];

			if(aUser.id == aId)
			{
				return aUser;
			};
		};

        if(myUser.id == aId)
        {
            return myUser;
        }

		return null;
	}

	public function selectUser(aId:String):Void
	{
		var User = getUser(aId);

		if(User == null)
		{
			return;
		};

		dispatcher.dispatchEvent(new DataEvent(MessageType.SELECT_USER, aId));
	};

	public function dispose():Void
	{
		matchedUsers = new Array<User>();
	};

	public function addEventListener(type:String, listener:Dynamic):Void
	{
        dispatcher.addEventListener(type, listener);
    };

    public function removeEventListener(type:String, listener:Dynamic):Void
    {
        dispatcher.removeEventListener(type, listener);
    };

	public static function getInstance():UserHandler
    {
        if (UserHandler.__instance == null)
            UserHandler.__instance = new UserHandler();
        return UserHandler.__instance;
    };
}