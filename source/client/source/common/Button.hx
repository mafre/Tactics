package common;

import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;

import common.Image;
import event.EventType;
import utils.SoundHandler;

class Button extends Sprite
{
	private var path:String;
	private var up:Sprite;
	private var down:Sprite;

	public function new(path:String)
	{
		super();

		if(path == null)
		{
			return;
		}

		up = new Image(path+"_up.png");
		addChild(up);

		down = new Image(path+"_down.png");
		addChild(down);
		down.visible = false;

		this.path = path;

		addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		addEventListener(MouseEvent.MOUSE_UP, mouseUp);
        addEventListener(MouseEvent.ROLL_OVER, mouseOver);
        addEventListener(MouseEvent.ROLL_OUT, mouseOut);
	}

	public function mouseDown(e:MouseEvent):Void
	{
		down.visible = true;
		up.visible = false;
		addEventListener(MouseEvent.ROLL_OUT, mouseUp);
		SoundHandler.playEffect("button5");
		dispatchEvent(new Event(EventType.BUTTON_PRESSED));
	}

	public function mouseUp(e:MouseEvent):Void
	{
		down.visible = false;
		up.visible = true;
		removeEventListener(MouseEvent.ROLL_OUT, mouseUp);
		dispatchEvent(new Event(EventType.BUTTON_RELEASED));
	}

    public function mouseOver(e:MouseEvent):Void
    {
        down.visible = true;
        up.visible = false;
    };

    public function mouseOut(e:MouseEvent):Void
    {
        down.visible = false;
        up.visible = true;
    };
}