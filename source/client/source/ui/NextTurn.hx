package ui;

import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;
import flash.geom.Point;
import flash.text.TextField;

import haxe.Timer;

import common.StageInfo;
import common.Image;
import common.GridSprite;
import event.EventType;
import event.EventBus;
import utils.SoundHandler;
import utils.TextfieldFactory;
import utils.PositionHelper;
import user.UserHandler;
import user.User;

import common.Button;

class NextTurn extends Sprite
{
    private var container:Sprite;
    private var info:TextField;
    private var modalBackground:GridSprite;

	public function new()
    {
        super();

        visible = false;

        container = new Sprite();
        addChild(container);

        modalBackground = new GridSprite("modal", 200, 200, true);
        container.addChild(modalBackground);

        info = TextfieldFactory.getDefault();
        container.addChild(info);

        EventBus.subscribe(EventTypes.ShowNextUser, show);
    };

    public function show(aUserId:String):Void
    {
        var user:User = UserHandler.getInstance().getUser(aUserId);

        info.text = user.userName;
        visible = true;

        resize();

        Timer.delay(hide, 1000);
    };

    private function hide():Void
    {
        visible = false;
        EventBus.dispatch(EventTypes.NextTurn);
    }

    public function resize():Void
    {
        info.x = modalBackground.width/2 - info.width/2;
        info.y = modalBackground.height/2 - info.height/2;
        container.x = StageInfo.stageWidth/2 - container.width/2;
        container.y = StageInfo.stageHeight/2 - container.height/2;
    };
}