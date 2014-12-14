package state;

import openfl.Assets;

import flash.display.Sprite;
import flash.events.Event;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;

import common.Image;
import event.EventType;
import event.EventBus;
import common.StageInfo;
import utils.SoundHandler;
import utils.SWFHandler;
import connection.ConnectionHandler;
import user.UserHandler;
import state.StateHandler;
import map.MapModel;
import ability.AbilityHandler;
import tile.TileHelper;
import entity.EntityHandler;

class Load extends State
{
	public function new():Void
	{
		super();
	};

    public override function init(?vars:Dynamic):Void
    {
        if (Multitouch.supportsTouchEvents)
        {
            Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
        };

        var soundHandler:SoundHandler = new SoundHandler();
        var swfHandler:SWFHandler = new SWFHandler();
        var eventBus:EventBus = new EventBus();

        ConnectionHandler.getInstance().init();
        UserHandler.getInstance().init();
        AbilityHandler.getInstance().init();

        var tile:Sprite = new Image("img/tile/default.png");
        TileHelper.tileWidth = tile.width/2;
        TileHelper.tileHeight = tile.height/2;

        if(false)
        {
            StateHandler.getInstance().setStateProgress("Connecting...");
            ConnectionHandler.getInstance().connect();
        }
        else
        {
            StateHandler.getInstance().setStateTest();
        };
    };
}