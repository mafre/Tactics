package connection;

import flash.events.Event;
import flash.events.EventDispatcher;

import com.gemioli.io.Socket;
import com.gemioli.io.events.SocketEvent;

import user.UserHandler;
import state.StateHandler;
import event.EventType;
import message.MessageHandler;

class ConnectionHandler
{
	static private var __instance:ConnectionHandler;
	static public var dispatcher:EventDispatcher;

	private var socketGame : Socket;

	public function new()
	{

	}

	public function init():Void
	{
		dispatcher = new EventDispatcher();

		socketGame = new Socket("http://localhost:5000/game", {transports : ["xhr-polling"]});
		//socketGame = new Socket("http://jatzy.herokuapp.com/game", {transports : ["xhr-polling"]});

		socketGame.addEventListener(SocketEvent.CONNECTING, function(event : SocketEvent) : Void
		{

		});

		socketGame.addEventListener(SocketEvent.CONNECT, function(event : SocketEvent) : Void
		{
			StateHandler.getInstance().setStateStart();
		});

		socketGame.addEventListener(SocketEvent.CONNECT_FAILED, function(event : SocketEvent) : Void
		{
			trace("connect failed");
		});

		socketGame.addEventListener(SocketEvent.ERROR, function(event : SocketEvent) : Void
		{
			trace("connect error");
		});

		MessageHandler.getInstance().init(socketGame);
	};

	public function connect():Void
	{
		StateHandler.getInstance().setStateProgress("Connecting...");
		socketGame.connect();
	};

	public function disconnect():Void
	{
		socketGame.disconnect();
	};

	public static function getInstance():ConnectionHandler
    {
        if (ConnectionHandler.__instance == null)
            ConnectionHandler.__instance = new ConnectionHandler();

        return ConnectionHandler.__instance;
    };
}