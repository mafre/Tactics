package common;

import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;
import flash.text.TextField;

import common.GridSprite;
import event.EventType;
import utils.TextfieldFactory;
import utils.SoundHandler;

class LabelButton extends Sprite
{
	private var path:String;
	private var up:GridSprite;
	private var down:GridSprite;
	private var labelTF:TextField;
	private var event:String;
	public var index:Int;
	private var isEnabled:Bool;

	public function new(path:String, label:String, ?aWidth:Float, ?event:String)
	{
		super();

		if(path == null)
		{
			return;
		};

		isEnabled = true;

		this.event = EventType.BUTTON_PRESSED;

		if(event != null)
		{
			this.event = event;
		};

		labelTF = TextfieldFactory.getButtonLabel();
		labelTF.text = label;

		up = new GridSprite("button1up", (aWidth != null) ? aWidth : labelTF.textWidth+50, labelTF.height+30, true);
		addChild(up);

		down = new GridSprite("button1down", (aWidth != null) ? aWidth : labelTF.textWidth+50, labelTF.height+30, true);
		addChild(down);
		down.visible = false;

		labelTF.x = up.width/2 - labelTF.width/2;
		labelTF.y = up.height/2 - labelTF.height/2;
		addChild(labelTF);

		this.path = path;

		addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		addEventListener(MouseEvent.ROLL_OVER, mouseOver);
		addEventListener(MouseEvent.ROLL_OUT, mouseOut);
	};

	public function enable():Void
	{
		if(isEnabled)
		{
			return;
		}

		isEnabled = true;
		this.alpha = 1;
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		addEventListener(MouseEvent.ROLL_OVER, mouseOver);
		addEventListener(MouseEvent.ROLL_OUT, mouseOut);
	};

	public function disable():Void
	{
		if(!isEnabled)
		{
			return;
		}

		isEnabled = false;
		this.alpha = 0.5;
		removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		removeEventListener(MouseEvent.ROLL_OVER, mouseOver);
		removeEventListener(MouseEvent.ROLL_OUT, mouseOut);
	};

    public function setText(aText:String):Void
    {
        labelTF.text = aText;
    }

	public function mouseDown(e:MouseEvent):Void
	{
		down.visible = true;
		up.visible = false;
		dispatchEvent(new Event(event));
	};

	public function mouseUp(e:MouseEvent):Void
	{
		down.visible = false;
		up.visible = true;
		dispatchEvent(new Event(EventType.BUTTON_RELEASED));
	};

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