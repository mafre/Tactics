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

class TargetTile extends TileBase
{
    private var asset:Image;
    private var id:Int;
    private var highlight:Bool;

    public function new(aId:Int):Void
    {
        super();

        id = aId;
        asset = new Image("img/tile/target.png");
        addChild(asset);
        type = EntityType.TARGET_TILE;
        highlight = true;
        layer = 1;

        addEventListener(MouseEvent.ROLL_OVER, rollOverTarget);
        addEventListener(MouseEvent.ROLL_OUT, rollOutTarget);

        EventBus.subscribe(EventTypes.ShowTargetTileWithId, showTargetTileWithId);
        EventBus.subscribe(EventTypes.ShowTargetTileWithPosition, showTargetTileWithPosition);
        EventBus.subscribe(EventTypes.CheckIfPositionIsAbilityTarget, checkIfPositionIsAbilityTarget);
        EventBus.subscribe(EventTypes.TargetSelected, TargetSelected);
        EventBus.subscribe(EventTypes.HideTargetTiles, hide);
        EventBus.subscribe(EventTypes.DeselectCharacter, hide);
        EventBus.subscribe(EventTypes.CancelAbility, hide);
        EventBus.subscribe(EventTypes.EndTurn, hide);

        addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
    };

    private function mouseDown(e:MouseEvent):Void
    {
        EventBus.dispatch(EventTypes.TargetSelected, super.getPosition());
    }

    private function TargetSelected(aId:Int):Void
    {
        hide();
    }

    private function showTargetTileWithId(aId:Int):Void
    {
        if (id == aId)
        {
            highlight = true;
            show();
        }
    }

    private function checkIfPositionIsAbilityTarget(aPosition:Point):Void
    {
        if (super.getPosition().x == aPosition.x && super.getPosition().y == aPosition.y)
        {
            highlight = false;
            show();
        }
    }

    private function showTargetTileWithPosition(aPosition:Point):Void
    {
        if (super.getPosition().x == aPosition.x && super.getPosition().y == aPosition.y)
        {
            highlight = false;
            show();
        }
    }

    private function rollOverTarget(e:MouseEvent):Void
    {
        if(highlight)
        {
            removeChild(asset);
            asset = new Image("img/tile/targetHighlight.png");
            addChild(asset);
        }
    }

    private function rollOutTarget(e:MouseEvent):Void
    {
        if(highlight)
        {
            removeChild(asset);
            asset = new Image("img/tile/target.png");
            addChild(asset);
        }
    }
}