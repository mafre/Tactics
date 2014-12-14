package ui;

import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;
import flash.geom.Point;

import common.StageInfo;
import common.Image;
import event.EventType;
import utils.PositionHelper;

class Bar extends Sprite
{
    private var top:Sprite;
    private var middle:Sprite;
    private var bottom:Sprite;

	public function new()
	{
		super();

        top = new Image("img/bar/top.png");
        middle = new Image("img/bar/middle.png");
        bottom = new Image("img/bar/bottom.png");

        addChild(bottom);
        addChild(middle);
        addChild(top);

        bottom.scaleX = bottom.scaleY = middle.scaleX = middle.scaleY = top.scaleX = top.scaleY = StageInfo.scale;

        top.y = bottom.height/2 - top.height/2;
        middle.y = bottom.height/2 - middle.height/2;
        top.x = bottom.width/2 - top.width/2;
        middle.x = bottom.width/2 - middle.width/2;
    };

    public function setPercent(aPercent:Float):Void
    {
        middle.scaleX = StageInfo.scale * aPercent;
    };
}