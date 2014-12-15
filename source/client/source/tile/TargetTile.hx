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

    public function new(aId:Int):Void
    {
        super();

        id = aId;
        asset = new Image("img/tile/target.png");
        addChild(asset);
        addEventListener(MouseEvent.ROLL_OVER, rollOverTarget);
        addEventListener(MouseEvent.ROLL_OUT, rollOutTarget);
        type = EntityType.TARGET_TILE;
        layer = 1;

        EventBus.subscribe(EventTypes.ShowMoveTile, showMoveTile);
        EventBus.subscribe(EventTypes.HideTargetTiles, hide);
        EventBus.subscribe(EventTypes.DeselectCharacter, hide);
        EventBus.subscribe(EventTypes.UseAbilityShowTargetTile, showAbilityTargetTile);
        EventBus.subscribe(EventTypes.CancelAbility, hide);
        EventBus.subscribe(EventTypes.EndTurn, hide);
    };

    private function showMoveTile(aId:Int):Void
    {
        if (id == aId)
        {
            show();
            addEventListener(MouseEvent.MOUSE_DOWN, moveCharacter);
        }
    }

    private function showAbilityTargetTile(aId:Int):Void
    {
        if (id == aId)
        {
            show();
            addEventListener(MouseEvent.MOUSE_DOWN, selectAbilityTarget);
        }
    }

    private function selectAbilityTarget(e:MouseEvent):Void
    {
        removeEventListener(MouseEvent.MOUSE_DOWN, selectAbilityTarget);
        EventBus.dispatch(EventTypes.TargetTileSelected, super.getPosition());
        EventBus.dispatch(EventTypes.HideTargetTiles);
    }

    private function deselectCharacter():Void
    {
        removeEventListener(MouseEvent.MOUSE_DOWN, moveCharacter);
        hide();
    }

    private function moveCharacter(e:MouseEvent):Void
    {
        removeEventListener(MouseEvent.MOUSE_DOWN, moveCharacter);
        EventBus.dispatch(EventTypes.TargetTileSelected, super.getPosition());
        EventBus.dispatch(EventTypes.HideTargetTiles);
    }

    private function rollOverTarget(e:MouseEvent):Void
    {
        removeChild(asset);
        asset = new Image("img/tile/targetHighlight.png");
        addChild(asset);
    }

    private function rollOutTarget(e:MouseEvent):Void
    {
        removeChild(asset);
        asset = new Image("img/tile/target.png");
        addChild(asset);
    }
}