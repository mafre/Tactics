package tile;

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
import character.CharacterView;

class SelectionTile extends TileBase
{
    private var tileType:Int;
    private var asset:Sprite;

    public function new():Void
    {
        super();
        asset = new Image("img/tile/selection1.png");
        addChild(asset);
        type = EntityType.SELECTION_TILE;
        layer = 2;
        visible = false;

        setPosition(new Point(0, 0));

        EventBus.subscribe(EventTypes.SelectCharacter, selectCharacter);
        EventBus.subscribe(EventTypes.DeselectCharacter, hide);
        EventBus.subscribe(EventTypes.EndTurn, hide);
        EventBus.subscribe(EventTypes.MoveCharacterToPosition, moveCharacterToPosition);
    };

    private function selectCharacter(aData:Array<Dynamic>):Void
    {
        var characterPos:Point = aData[1];

        setPosition(characterPos);
        visible = true;
    }

    private function moveCharacterToPosition(aData:Array<Dynamic>):Void
    {
        var characterPos:Point = aData[1];

        setPosition(characterPos);
    }
}