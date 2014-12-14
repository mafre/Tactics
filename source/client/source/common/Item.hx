
package common;

import flash.utils.Object;
import flash.events.Event;

class DataEvent extends Event
{
	public var data:Object;

	public function new(type:String, data:Object, bubbles:Bool=false, cancelable:Bool=false):Void
	{
		this.data = data;
		super(type, bubbles, cancelable);
	}

	public override function clone():Event
    {
        return new DataEvent(type, data, bubbles, cancelable);
    }
}