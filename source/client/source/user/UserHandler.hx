package user;

import flash.display.Sprite;
import flash.geom.Point;
import flash.display.MovieClip;
import flash.utils.Object;
import flash.events.Event;
import flash.events.EventDispatcher;

import event.DataEvent;
import event.EventType;
import common.StageInfo;
import message.Message;
import message.MessageType;
import state.StateHandler;
import haxe.ds.StringMap;
import connection.ConnectionHandler;
import utils.PositionHelper;

import user.User;

class UserHandler
{
	static private var __instance:UserHandler;
	static public var dispatcher:EventDispatcher;

	public var userId:String;
    public var myUser:User;
	public var matchedUsers:Array<User>;

	public function new()
	{

	};

	public function init():Void
	{
		dispatcher = new EventDispatcher();
		matchedUsers = new Array<User>();
	};

	public function setUserId(aId:String):Void
	{
		userId = aId;
	};

    public function setMyUser(aId:String, aName:String):Void
    {
        myUser = new User(aId, aName);
    }

	public function addMatchedUser(aId:String, aName:String):Void
	{
		var user:User = new User(aId, aName);
		matchedUsers.push(user);
	};

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