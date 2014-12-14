package state;

import flash.display.Sprite;

import common.StageInfo;
import state.StateHandler;
import state.State;

import entity.EntityHandler;
import map.MapView;
import map.MapModel;
import ui.UI;

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
	};

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