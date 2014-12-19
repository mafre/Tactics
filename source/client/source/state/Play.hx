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
        var scale: Float = e.extra;
        var spt = container.parent.localToGlobal(new Point(container.x, container.y));
        var dx = spt.x - e.stageX, dy = spt.y - e.stageY;
        var angle = Math.atan2(dy, dx);
        var nowlen = new Point(dx, dy).length;
        var newlen = nowlen * scale;
        var newpos = Point.polar(newlen, angle);
        newpos.offset(e.stageX, e.stageY);
        newpos = container.parent.globalToLocal(newpos);

        container.scaleX *= scale;
        container.scaleY *= scale;
        container.x = newpos.x;
        container.y = newpos.y;
    }

    private function onPan(e:RoxGestureEvent):Void
    {
        var pt = cast(e.extra,Point);
        container.x += pt.x;
        container.y += pt.y;
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