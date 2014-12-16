package obstacle;

import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Object;
import flash.geom.Point;

import common.StageInfo;
import common.GridSprite;
import tile.TileType;
import tile.TileBase;
import common.Image;
import entity.Entity;
import entity.EntityType;
import event.EventType;
import event.EventBus;
import map.MapModel;

class Obstacle extends TileBase
{
    private var obstacleType:ObstacleType;
    private var asset:Sprite;

    public function new():Void
    {
        super();
        type = EntityType.OBSTACLE;
        layer = 3;
    };

    public function setType(aObstacleType:ObstacleType):Void
    {
        obstacleType = aObstacleType;

        switch(obstacleType)
        {
            case ObstacleType.Rock1:

                asset = new Image("img/obstacle/stone1.png");
                addChild(asset);

            case ObstacleType.Tree1:

                asset = new Image("img/obstacle/tree1.png");
                addChild(asset);

            default:
        };

        var tile:Sprite = new Image("img/tile/default.png");

        asset.x = tile.width/2 - asset.width/2;
        asset.y = tile.height/2 - asset.height;
    }
}