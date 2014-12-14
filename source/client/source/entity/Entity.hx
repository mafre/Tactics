package entity;

import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;
import flash.display.MovieClip;

import flash.geom.Point;
import utils.SWFHandler;

class Entity extends Sprite
{
    public var type:String;
    public var layer:Int;
    public var removed:Bool;

	public function new()
	{
		super();

		removed = false;
		mouseEnabled = false;
		mouseChildren = false;
	};

    public function show():Void
    {
        visible = true;
    }

    public function hide():Void
    {
        visible = false;
    }

	public function handleCollision(entity:Entity):Void
	{

	};

	public function update():Void
	{

	};

    public function remove():Void
    {
        removed = true;
    }

    public function dispose():Void
    {

    };
}