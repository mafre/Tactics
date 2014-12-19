package common;

import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextFormat;
import flash.text.TextField;
import flash.text.TextFormatAlign;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;

import common.Image;
import haxe.Timer;
import event.EventType;
import event.DataEvent;

class Animation extends Sprite
{
	public var delay:Int;
	public var newDelay:Int;
	public var path:Dynamic;
	private var images:Array<Image>;
	public var index:Int;
	private var frames:Array<Int>;
	private var dispatchIndex:Int;
	private var current:Image;
	private var b:Bitmap;
	public var isActive:Bool;
	private var loop:Bool;
	public var flipX:Bool;
	private var eventType:String;

	public function new(?aLoop:Bool, ?aIspatchIndex:Int, ?aEventType:String)
	{
		super();
		newDelay = 6;
		index = -1;
		isActive = false;
		delay = 0;
		this.loop = false;
		flipX = false;
		dispatchIndex = -1;
		images = [];

		if(aLoop != null)
		{
			loop = aLoop;
		}

		if(aIspatchIndex != null)
		{
			dispatchIndex = aIspatchIndex;
		}

		if(aEventType != null)
		{
			eventType = aEventType;
		}
	};

	public function show():Void
	{
		dispose();
		start();
	}

	public function setPath(aPath:String):Void
	{
		path = aPath;
		dispose();

		if(isActive)
		{
			start();
		}
	}

	public function setFrames(aFrames:Array<Int>):Void
	{
		frames = aFrames;
		dispose();

		if(isActive)
		{
			start();
		}
	}

	public function setDelay(delay:Int):Void
	{
		this.newDelay = delay;
	}

	public function setPaths(paths:Array<String>):Void
	{

	}

	public function getImage():Image
	{
		var image:Image = new Image(path+frames[0]+".png");
		return image;
	}

	public function start():Void
	{
		if(path == null)
		{
			trace("Path is not set");
			return;
		}

		if(frames == null)
		{
			trace("Frames is not set");
			return;
		}

		for (i in 0...frames.length)
		{
			var i0:Int = frames[i];
			var p:String = path+i0+".png";
			var img:Image = new Image(p, flipX);
			addChild(img);
			img.visible = false;
			images.push(img);
		}

		images[0].visible = true;

		index = -1;
		isActive = true;
		delay = 0;
	}

	public function animate():Void
	{
		if(!isActive)
		{
			return;
		}

		if(this.parent == null)
		{
			return;
		}

		if(loop)
		{
			if(index == images.length-1)
			{
				index = -1;
			}
		}
		else
		{
			if(index == images.length-1)
			{
				hide();
				dispose();
				dispatchEvent(new DataEvent(EventType.ANIMATION_COMPLETE, this, true));
				return;
			}
		}

		if(current != null)
		{
			current.visible = false;
		}

		index++;

		if(dispatchIndex != -1)
		{
			if(index == dispatchIndex)
			{
				if(eventType != null)
				{
					dispatchEvent(new Event(eventType, true));
				}
				else
				{
					dispatchEvent(new Event(EventType.ANIMATION_EVENT));
				}
			}
		}

		current = images[index];
		current.visible = true;
		dispatchEvent(new Event(EventType.ANIMATION_UPDATE));
	}

    public function setIndex(aIndex:Int):Void
    {
        if(current != null)
        {
            current.visible = false;
        }

        index = aIndex;
        current = images[index];
        current.visible = true;
    }

	public function update():Void
	{
		delay--;

		if(delay <= 0)
		{
			animate();
			delay = newDelay;
		}
	}

	public function dispose():Void
	{
		for (i in 0...images.length)
		{
			var i0:Image = images[i];
			i0.parent.removeChild(i0);
			i0 = null;
		}

		images = new Array<Image>();
	}

	public function stop():Void
	{
		isActive = false;
	}

	public function hide():Void
	{
		isActive = false;
		if(this.parent != null)
		{
			this.parent.removeChild(this);
		}
	}
}