package common;

import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Object;

import utils.TextfieldFactory;
import utils.SoundHandler;
import utils.SWFHandler;
import common.StageInfo;
import common.GridSprite;
import common.Button;
import common.LabelButton;
import common.ToggleButton;
import event.EventType;
import common.Image;
import common.Slider;

class Slider extends Sprite
{
	private var track:GridSprite;
	private var handle:MovieClip;
	private var startX:Int;
	private var startHandleX:Int;
	public var percent:Float;

	public function new():Void
	{
		super();
		track = new GridSprite("track", 250, 50, true);
		handle = SWFHandler.getMovieclip("handle");
		addChild(track);
		addChild(handle);
		handle.y = track.height/2 - handle.height/2;
		handle.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
		track.addEventListener(MouseEvent.MOUSE_DOWN, trackMouseDown);
	};

	public function trackMouseDown(e:MouseEvent):Void
	{
		var newXPos:Int = Math.round(e.localX-handle.width/2);

		if(newXPos < 0)
		{
			newXPos = 0;
		}
		else if(newXPos > track.width-handle.width)
		{
			newXPos = Math.floor(track.width-handle.width);
		}

		handle.x = newXPos;
		percent = handle.x/(track.width-handle.width);
		dispatchEvent(new Event(EventType.SLIDER_MOVE));
		dispatchEvent(new Event(EventType.SLIDER_CHANGED));
	}

	public function handleMouseDown(e:MouseEvent):Void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		startHandleX = Math.floor(handle.x);
		startX = Math.round(e.stageX);
	}

	public function mouseUp(e:MouseEvent):Void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		dispatchEvent(new Event(EventType.SLIDER_CHANGED));
	}

	public function mouseMove(e:MouseEvent):Void
	{
		var xPos:Int = Math.round(startX - e.stageX);
		var newXPos:Int = Math.round(track.x-xPos)+startHandleX;

		if(newXPos < 0)
		{
			newXPos = 0;
		}
		else if(newXPos > track.width-handle.width)
		{
			newXPos = Math.floor(track.width-handle.width);
		}

		handle.x = newXPos;
		percent = newXPos/(track.width-handle.width);
		dispatchEvent(new Event(EventType.SLIDER_MOVE));
	}

	public function setValue(value:Float):Void
	{
		handle.x = value*(track.width-handle.width);
	}

	public function enabled(enabled:Bool):Void
	{
		this.mouseEnabled = enabled;
		this.mouseChildren = enabled;
		alpha = enabled ? 1 : 0.5;
	}
}