package tile;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Object;
import flash.geom.Point;

import common.Image;
import entity.Entity;
import tile.TileHelper;

class TileBase extends Entity
{
    private var position:Point;
    private var isObstacle:Bool;

    public function new():Void
    {
        super();
        mouseEnabled = true;
        mouseChildren = true;
    };

    public function getPosition():Point
    {
        return position;
    }

    public function setPosition(aPosition:Point):Void
    {
        position = aPosition;
        updatePosition();
    }

    public function setPositionNoUpdate(aPosition:Point):Void
    {
        position = aPosition;
    }

    public function updatePosition():Void
    {
        x = (position.x - position.y - 1) * TileHelper.tileWidth;
        y = (position.x + position.y) * TileHelper.tileHeight;
    }
}