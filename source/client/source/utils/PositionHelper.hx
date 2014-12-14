package utils;

import flash.geom.Point;
import flash.display.MovieClip;
import flash.display.Sprite;

class PositionHelper
{
	static public var ALIGN_LEFT:String                	= "AlignLeft";
	static public var ALIGN_CENTER:String 				= "AlignLCenter";
	static public var ALIGN_RIGHT:String 				= "AlignLRight";
	static public var ALIGN_CENTER_W_H:String 			= "AlignLCenterWH";

	public static inline function alignHorizontally(items:Array<Dynamic>, position:Point, ?gap:Float, ?alignToBottom:Bool, ?alignVerticallyToItem:Dynamic, ?fixedWidth:Int):Void
	{
		var posX:Float = position.x;
		var posY:Float = position.y;

		for (item in items)
		{
			item.x = posX;

			if(alignVerticallyToItem != null)
			{
				item.y = posY + alignVerticallyToItem.height/2 - item.height/2;
			}
			else
			{
				item.y = posY;
			}

			if(alignToBottom != null && alignToBottom)
			{
				item.y -= item.height;
			}

			if(fixedWidth != null)
			{
				posX += fixedWidth;
			} 
			else
			{
				posX += item.width;

				if(gap != null)
				{
					posX += gap;
				}
			}
		}
	}

	public static inline function alignVertically(items:Array<Dynamic>, position:Point, ?gap:Float, ?align:String, ?container:Sprite):Void
	{
		var posX:Float = position.x;
		var posY:Float = position.y;

		for (item in items)
		{
			if(item != null)
			{
				item.x = posX;
				item.y = posY;

				posY += item.height;
			}

			if(gap != null)
			{
				posY += gap;
			};
		};

		if(align != null && align == PositionHelper.ALIGN_CENTER_W_H && container != null)
		{
			var startY:Float = container.height/2 - posY/2;

			for (item in items)
			{
				if(item != null)
				{
					item.y += startY;
				};
			};
		};

		if(align != null)
		{
			for (item in items)
			{
				if(item != null)
				{
					if(container != null)
					{
						switch (align)
						{
							case PositionHelper.ALIGN_CENTER:

								item.x = container.x+container.width/2-item.width/2;

							case PositionHelper.ALIGN_CENTER_W_H:

								item.x = container.x+container.width/2-item.width/2;
						};
					};
					else
					{
						switch (align)
						{
							case PositionHelper.ALIGN_LEFT:

								item.x = posX - item.width;

							case PositionHelper.ALIGN_CENTER:

								item.x = -item.width/2;
						};
					};
				}
			};
		};
	}

	public static inline function alignTiled(items:Array<Dynamic>, position:Point, gap:Float, maxWidth:Float):Void
	{
		var posX:Float = position.x;
		var posY:Float = position.y;

		for (item in items)
		{
			item.x = posX;
			item.y = posY;

			posX += item.width + gap;
		}
	}

	public static inline function centerInMovieclip(mc1:MovieClip, mc2:MovieClip):Void
	{
		mc1.x = mc2.x + mc2.width/2 - mc1.width/2;
		mc1.y = mc2.y + mc2.height/2 - mc1.height/2;
	}
}