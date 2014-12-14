package common;

import flash.events.EventDispatcher;
import flash.events.Event;

import event.EventType;

class StageInfo
{
	static public var dispatcher:EventDispatcher	= new EventDispatcher();
	static public var initialized:Bool				= false;
	static public var stageWidth:Int				= 0;
	static public var stageHeight:Int				= 0;
	static public var touchEnabled:Bool				= false;
    static public var scale:Float                   = 4;

	public static function resize(width:Int, height:Int):Void
	{
		stageWidth = width;
		stageHeight = height;
		dispatcher.dispatchEvent(new Event(EventType.STAGE_RESIZED));

		if(!initialized)
		{
			dispatcher.dispatchEvent(new Event(EventType.STAGE_INITIALIZED));
			initialized = true;
		}
	}

	public static function addEventListener(type:String, listener:Dynamic):Void
	{
        dispatcher.addEventListener(type, listener);
    }

    public static function removeEventListener(type:String, listener:Dynamic):Void
    {
        dispatcher.removeEventListener(type, listener);
    }
}