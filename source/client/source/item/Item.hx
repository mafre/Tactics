package item;

import flash.events.EventDispatcher;
import flash.events.Event;
import flash.utils.Function;
import flash.display.Sprite;
import flash.geom.Point;

import motion.Actuate;

import event.EventType;
import common.StageInfo;
import entity.Entity;
import entity.EntityType;
import tile.TileBase;
import tile.TileHelper;
import common.Image;

enum ItemState
{
    Bouncing;
    OnMap;
    Inventory;
}

class Item extends TileBase
{
    private var id:Int;
    private var asset:Sprite;
    private var state:ItemState;
    private var dropYSpeed:Float;
    private var dropYDeacc:Float;
    private var dropXSpeed:Float;
    private var targetPosition:Point;

    public function new():Void
    {
        super();
        asset = new Image("img/item/default.png");
        asset.y -= asset.height;
        asset.x -= asset.width/2;
        addChild(asset);

        layer = 5;
    };

    public function getPositionInPixels(xPos:Float, yPos:Float):Point
    {
        return new Point((xPos - yPos - 1) * TileHelper.tileWidth/2, (xPos + yPos) * TileHelper.tileHeight/2);
    }

    public function drop(aStartPosition:Point, aTargetPosition:Point):Void
    {
        targetPosition = getPositionInPixels(aTargetPosition.x, aTargetPosition.y);
        var startPos:Point = getPositionInPixels(aStartPosition.x, aStartPosition.y);
        x = startPos.x;
        y = startPos.y;
        dropYSpeed = 4;
        dropYDeacc = 0.4;
        dropXSpeed = (targetPosition.x - startPos.x)/100;
        state = ItemState.Bouncing;
    }

    private function updateBounce():Void
    {
        dropYSpeed -= dropYDeacc;
        y -= dropYSpeed;
        x -= dropXSpeed;
    }

    public override function update():Void
    {
        switch (state)
        {
            case ItemState.Bouncing:

                updateBounce();

            default:

        }
    }
}