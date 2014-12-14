package ui;

import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;

import common.Image;
import event.EventBus;
import utils.SoundHandler;
import common.StageInfo;

class Avatar extends Sprite
{
	private var asset:Sprite;
    private var id:Int;

	public function new()
	{
		super();
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
        scaleX = scaleY = StageInfo.scale;
	}

    public function init(aId:Int, aPath:String):Void
    {
        id = aId;

        if(asset != null)
        {
            asset.parent.removeChild(asset);
        }

        asset = new Image("img/avatar/"+aPath+".png");
        addChild(asset);
    };

	public function mouseDown(e:MouseEvent):Void
	{
        EventBus.dispatch(EventTypes.SelectAvatar, id);
	};
}