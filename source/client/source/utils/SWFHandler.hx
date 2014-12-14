package utils;

import openfl.Assets;
import format.SWF;

import flash.media.*;
import flash.events.Event;
import flash.display.MovieClip;

class SWFHandler
{
	static public var swf:SWF;

	public function new()
	{
		swf = new SWF(Assets.getBytes("swf/assets.swf"));
	}

	public static function getMovieclip(id:String):MovieClip
	{
		return swf.createMovieClip(id);
	}
}