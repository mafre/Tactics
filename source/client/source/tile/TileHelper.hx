package tile;

import flash.geom.Point;

import tile.TileBase;
import character.CharacterModel;
import character.CharacterView;

class TileHelper
{
    static public var tileWidth:Float                   = 0;
    static public var tileHeight:Float                  = 0;

	public static function getDistance(startTile:TileBase, endTile:TileBase):Float
    {
        var startPos:Point = startTile.getPosition();
        var endPos:Point = endTile.getPosition();

        var xDistance = Math.abs(endPos.x - startPos.x);
        var yDistance = Math.abs(endPos.y - startPos.y);

        return xDistance + yDistance;
    }

    public static function getDistanceBetweenPoint(start:Point, target:Point):Int
    {
        var xDistance = Math.abs(target.x - start.x);
        var yDistance = Math.abs(target.y - start.y);

        return Math.floor(xDistance + yDistance);
    }

    public static function getDirection(startPos:Point, endPos:Point ):Direction
    {
        var xDistance = endPos.x - startPos.x;
        var yDistance = endPos.y - startPos.y;

        var direction:Direction = null;

        if(Math.abs(xDistance) > Math.abs(yDistance))
        {
            if(xDistance > 0)
            {
                direction = Direction.Right;
            }
            else
            {
                direction = Direction.Left;
            }
        }
        else
        {
            if(yDistance > 0)
            {
                direction = Direction.Down;
            }
            else
            {
                direction = Direction.Up;
            }
        }

        return direction;
    }
}