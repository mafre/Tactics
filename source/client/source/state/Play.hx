package state;

import flash.display.Sprite;

import common.StageInfo;
import state.StateHandler;
import state.State;

import entity.EntityHandler;
import map.MapView;
import map.MapModel;
import ui.UI;
import event.EventBus;

import flash.display.DisplayObject;
import flash.geom.Point;

import com.roxstudio.haxe.gesture.RoxGestureAgent;
import com.roxstudio.haxe.gesture.RoxGestureEvent;

class Play extends State
{
    private var entityHandler:EntityHandler;
    private var mapView:MapView;
    private var entityView:Sprite;
    private var ui:UI;
    private var gameView:Sprite;

	public function new()
	{
		super();
        entityHandler = EntityHandler.getInstance();

        mapView = new MapView(new MapModel());
        container.addChild(mapView);

        entityView = new Sprite();
        container.addChild(entityView);

        container.scaleX = container.scaleY = StageInfo.scale;

        entityHandler.setContainer(entityView);

        ui = new UI();
        addChild(ui);

        var roxAgent:RoxGestureAgent = new RoxGestureAgent(container, RoxGestureAgent.GESTURE);
        container.addEventListener(RoxGestureEvent.GESTURE_PINCH, onPinch);
        container.addEventListener(RoxGestureEvent.GESTURE_PAN, onPan);
	};

    private function onPinch(e:RoxGestureEvent):Void
    {
        var sp = cast(e.target, DisplayObject);
        var scale: Float = e.extra;
        var spt = sp.parent.localToGlobal(new Point(sp.x, sp.y));
        var dx = spt.x - e.stageX, dy = spt.y - e.stageY;
        var angle = Math.atan2(dy, dx);
        var nowlen = new Point(dx, dy).length;
        var newlen = nowlen * scale;
        var newpos = Point.polar(newlen, angle);
        newpos.offset(e.stageX, e.stageY);
        newpos = sp.parent.globalToLocal(newpos);

        sp.scaleX *= scale;
        sp.scaleY *= scale;
        sp.x = newpos.x;
        sp.y = newpos.y;
    }

    private function onPan(e:RoxGestureEvent):Void
    {
        var sp = cast(e.target, DisplayObject);
        var pt = cast(e.extra,Point);
        sp.x += pt.x;
        sp.y += pt.y;
    }

    public override function init(?vars:Dynamic):Void
    {
        mapView.loadMap(0);
    };

    public override function update(time:Int):Void
    {
        entityHandler.update();
    };

	public override function resize():Void
	{
		super.resize();
        ui.resize();
        super.centerContainerSkipWidth();
	};

	public override function dispose():Void
	{

	};
}