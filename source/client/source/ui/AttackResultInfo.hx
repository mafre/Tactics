package ui;

import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;
import flash.geom.Point;
import flash.text.TextField;

import common.StageInfo;
import common.Image;
import event.EventType;
import utils.PositionHelper;
import utils.TextfieldFactory;
import entity.Entity;

import motion.Actuate;
import motion.easing.Quad;

class AttackResultInfo extends Entity
{
    private var tf:TextField;

	public function new(aInfo:String)
	{
		super();

        layer = 7;
        tf = TextfieldFactory.getAttackResultInfo();
        tf.text = aInfo;
        addChild(tf);
        scaleX = scaleY = 1/StageInfo.scale;
    };

    public override function init():Void
    {
        Actuate.tween(this, 1, { x: x, y: y - 10 }, false).ease (Quad.easeOut).onComplete(remove);
    }
}