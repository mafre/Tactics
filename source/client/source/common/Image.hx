package common;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import openfl.Assets;
import flash.geom.Matrix;

class Image extends Sprite
{
	private var bmd:BitmapData;
	private var bm:Bitmap;
	private var flipX:Bool;
	private var path:String;

	public function new(?path:String, ?flipX)
	{
		super();

		if(path == null)
		{
			return;
		}

		this.path = path;
		this.flipX = false;

		var tempBmd:BitmapData = Assets.getBitmapData(path);

		if(flipX != null && flipX)
		{
			this.flipX = flipX;
			bmd = flipBitmapData(tempBmd);
			bm = new Bitmap(bmd, PixelSnapping.AUTO, false);
			addChild(bm);
		}
		else
		{
			bmd = new BitmapData(tempBmd.width, tempBmd.height, true, 0x000000);
			bmd.draw(tempBmd);
			bm = new Bitmap(bmd, PixelSnapping.AUTO, false);
			addChild(bm);
		}

		mouseChildren = false;
		buttonMode = false;
	}

	private function flipBitmapData(original:BitmapData, axis:String = "x"):BitmapData
	{
	     var flipped:BitmapData = new BitmapData(original.width, original.height, true, 0);
	     var matrix:Matrix;
	     if(axis == "x"){
	          matrix = new Matrix( -1, 0, 0, 1, original.width, 0);
	     } else {
	          matrix = new Matrix( 1, 0, 0, -1, 0, original.height);
	     }
	     flipped.draw(original, matrix, null, null, null, false);
	     return flipped;
	}

	public function addBitmap(path:String):Void
	{
		var bmd0:BitmapData = Assets.getBitmapData(path);
		bmd.draw(bmd0);
	}

	public function center():Void
	{
		bm.x = -bm.width/2;
		bm.y = -bm.height/2;
	}

    public function centerHorizontally():Void
    {
        bm.x = -bm.width/2;
    }

	public function duplicate():Image
	{
		var img:Image = new Image(path, flipX);
		return img;
	}
}