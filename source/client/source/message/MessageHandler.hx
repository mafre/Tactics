package message;

import flash.events.Event;
import flash.events.EventDispatcher;

import com.gemioli.io.Socket;
import com.gemioli.io.events.SocketEvent;

import user.UserHandler;
import event.EventType;
import message.Message;
import message.MessageType;
import state.StateHandler;

class MessageHandler
{
	static private var __instance:MessageHandler;
	static public var dispatcher:EventDispatcher;

	private var socket : Socket;

	public function new()
	{

	};

	public function init(socket:Socket):Void
	{
		this.socket = socket;
		dispatcher = new EventDispatcher();
		socket.addEventListener("ServerMessage", handleMessage);
	};

	private function handleMessage(event:SocketEvent):Void
	{
		var aMessage = event.args[0];

        trace(aMessage.type);

		switch(aMessage.type)
		{
			case MessageType.CREATE_EMAIL_TAKEN:
				dispatcher.dispatchEvent(new Event(MessageType.CREATE_EMAIL_TAKEN));

			case MessageType.LOGIN_WRONG_PASSWORD:
				dispatcher.dispatchEvent(new Event(MessageType.LOGIN_WRONG_PASSWORD));

			case MessageType.LOGIN_USER_NOT_FOUND:
				dispatcher.dispatchEvent(new Event(MessageType.LOGIN_USER_NOT_FOUND));

			case MessageType.USER_CREATED:

                var id:String = cast(aMessage.data.id, String);
                var userName:String = cast(aMessage.data.userName, String);
                UserHandler.getInstance().setMyUser(id, userName);

				StateHandler.getInstance().setStateLobby();

			case MessageType.LOGGED_IN:
                var id:String = cast(aMessage.data.id, String);
                var userName:String = cast(aMessage.data.userName, String);
                UserHandler.getInstance().setMyUser(id, userName);
                dispatcher.dispatchEvent(new Event(MessageType.LOGGED_IN));
				StateHandler.getInstance().setStateLobby();

			case MessageType.SET_USER_ID:
				var id:String = cast(aMessage.data.id, String);
				UserHandler.getInstance().setUserId(id);

			case MessageType.ADD_MATCHED_USER:
				var id:String = cast(aMessage.data.id, String);
                var userName:String = cast(aMessage.data.userName, String);
				UserHandler.getInstance().addMatchedUser(id, userName);

			case MessageType.REMOVE_USER:
				var id = cast(aMessage.data.id, String);
				UserHandler.getInstance().removeUser(id);

			case MessageType.SELECT_USER:
				var id:String = cast(aMessage.data.id, String);
				UserHandler.getInstance().selectUser(id);

            case MessageType.JOIN_GAME:
                StateHandler.getInstance().setStatePlay();
		};
	};

	public function sendMessage(aMessage:Message):Void
	{
        trace(aMessage.type);
		socket.emit("ClientMessage", aMessage);
	};

	public static function getInstance():MessageHandler
    {
        if (MessageHandler.__instance == null)
            MessageHandler.__instance = new MessageHandler();

        return MessageHandler.__instance;
    };
}