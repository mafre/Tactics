package state;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.geom.Point;
import flash.events.EventDispatcher;

import haxe.Timer;

import utils.TextfieldFactory;
import utils.PositionHelper;
import connection.ConnectionHandler;
import common.StageInfo;
import common.GridSprite;
import common.Button;
import common.LabelButton;
import common.ImageButton;
import event.EventType;
import common.Image;
import user.UserHandler;
import state.CreateAccount;
import state.Friends;
import state.Lobby;
import state.Login;
import state.Start;
import state.Test;
import state.Play;
import state.Progress;
import state.Load;
import state.State;

class StateHandler
{
    static public inline var delay:Int = 25;

    static public var STATE_NONE:String                 = "StateNone";
    static public var STATE_LOAD:String                 = "StateLoad";
    static public var STATE_START:String                = "StateStart";
    static public var STATE_CREATE_ACCOUNT:String       = "StateCreateAccount";
    static public var STATE_FRIENDS:String              = "StateFriends";
    static public var STATE_PROGRESS:String             = "StateProgress";
    static public var STATE_LOBBY:String                = "StateLobby";
    static public var STATE_LOGIN:String                = "StateLogin";
    static public var STATE_TEST:String                 = "StateTest";
    static public var STATE_PLAY:String                 = "StatePlay";
    static public var STATE_SCORE:String                = "StateScore";

    static public var __instance:StateHandler;
    static public var dispatcher:EventDispatcher;

    private var container:Sprite;
    private var state:String;
	private var currentState:State;
    private var timer:Timer;
    private var time:Int;

	public function new()
	{

	};

	public function init(container:Sprite):Void
	{
        this.container = container;

        StageInfo.addEventListener(EventType.STAGE_RESIZED, resize);
        flash.Lib.current.addEventListener(Event.ACTIVATE, resume);
        flash.Lib.current.addEventListener(Event.DEACTIVATE, pause);

        state = STATE_NONE;
		dispatcher = new EventDispatcher();

        stageResized();

        time = 0;
        timer = new haxe.Timer(delay);
        timer.run = update;
	};

    private function stageResized(event:Event = null):Void
    {
        var v1:Int = this.container.stage.stageWidth;
        var v2:Int = this.container.stage.stageHeight;

        if(v1 > v2)
        {
            StageInfo.resize(v1, v2);
        }
        else
        {
            StageInfo.resize(v2, v1);
        }
    };

    public function setStateLoad():Void
    {
        setState(StateHandler.STATE_LOAD);
    };

    public function setStateTest():Void
    {
        setState(StateHandler.STATE_TEST);
    };

    public function setStateStart():Void
    {
        setState(StateHandler.STATE_START);
    };

    public function setStateCreateAccount():Void
    {
        setState(StateHandler.STATE_CREATE_ACCOUNT);
    };

    public function setStateFriends():Void
    {
        setState(StateHandler.STATE_FRIENDS);
    };

    public function setStateProgress(text:Dynamic = null):Void
    {
        setState(StateHandler.STATE_PROGRESS, text);
    };

    public function setStateLobby():Void
    {
        setState(StateHandler.STATE_LOBBY);
    };

    public function setStateLogin():Void
    {
        setState(StateHandler.STATE_LOGIN);
    };

    public function setStatePlay():Void
    {
        setState(StateHandler.STATE_PLAY);
    };

    public function setState(aState:String, vars:Dynamic = null):Void
    {
        state = aState;
        time = 0;

        if(currentState != null)
		{
			currentState.dispose();
			currentState.parent.removeChild(currentState);
		};

        switch (state)
        {
            case StateHandler.STATE_LOAD:
                currentState = new Load();

            case StateHandler.STATE_TEST:
                currentState = new Test();

            case StateHandler.STATE_START:
                currentState = new Start();

            case StateHandler.STATE_LOBBY:
                currentState = new Lobby();

            case StateHandler.STATE_PLAY:
                currentState = new Play();

            case StateHandler.STATE_LOGIN:
                currentState = new Login();

            case StateHandler.STATE_FRIENDS:
                currentState = new Friends();

            case StateHandler.STATE_CREATE_ACCOUNT:
                currentState = new CreateAccount();

            case StateHandler.STATE_PROGRESS:
                currentState = new Progress();
        };

        if(currentState != null)
        {
            container.addChild(currentState);
            currentState.init(vars);
            currentState.resize();
        };
    };

    private function pause(?e:Dynamic):Void
    {
        timer.stop();
    };

    private function resume(?e:Dynamic):Void
    {
        timer = new haxe.Timer(delay);
        timer.run = update;
    };

    public function update():Void
    {
        time++;

        if(currentState != null)
        {
            currentState.update(time);
        };
    };

    public function resize(?e:Event):Void
    {
        if(currentState != null)
        {
            currentState.resize();
        };
    };

	public static function getInstance():StateHandler
    {
        if (StateHandler.__instance == null)
            StateHandler.__instance = new StateHandler();

        return StateHandler.__instance;
    };
}