package character;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.geom.Point;

import ability.Ability;
import ability.AbilityType;
import entity.Entity;
import entity.EntityType;
import common.Animation;
import common.GridSprite;
import common.Image;
import event.EventType;
import event.EventBus;
import utils.SoundHandler;
import tile.TileBase;
import tile.TileHelper;

class CharacterView extends TileBase
{
    public var id:Int;
    private var asset:Animation;

	public function new(aId:Int, aPath:String)
	{
        super();

        type = EntityType.CHARACTER;
        layer = 3;
        id = aId;

        asset = new Animation(true);
        asset.setFrames([1, 2]);
        asset.setDelay(12);
        asset.setPath(aPath);
        addChild(asset);
        asset.start();
        asset.x = TileHelper.tileWidth - asset.width/2;
        asset.y = TileHelper.tileHeight - asset.height;

        EventBus.subscribe(EventTypes.MoveCharacterToPosition, moveToPosition);
        EventBus.subscribe(EventTypes.SetCharacterEnabled, setEnabled);
        EventBus.subscribe(EventTypes.CharacterDamaged, characterDamaged);
        EventBus.subscribe(EventTypes.CharacterKilled, characterKilled);
	};

    private function setEnabled(aData:Array<Dynamic>):Void
    {
        var enabled:Bool = aData[1];

        if(id == aData[0])
        {
            if(enabled)
            {
                addEventListener(MouseEvent.CLICK, characterClicked);
            }
            else
            {
                removeEventListener(MouseEvent.CLICK, characterClicked);
            }
        }
    }

    private function characterDamaged(aData:Array<Dynamic>):Void
    {
        var characterId:Int = aData[0];

        if(id == characterId)
        {

        }
    }

    private function characterKilled(aData:Array<Dynamic>):Void
    {
        var characterId:Int = aData[0];

        if(id == characterId)
        {
            super.remove();
        }
    }

    private function characterClicked(e:MouseEvent):Void
    {
        EventBus.dispatch(EventTypes.DeselectCharacter);
        EventBus.dispatch(EventTypes.SelectCharacter, [id, super.getPosition()]);
        EventBus.dispatch(EventTypes.UpdateAbilities, [id, super.getPosition()]);
    }

    private function moveToPosition(aData:Array<Dynamic>):Void
    {
        if(id == aData[0])
        {
            super.setPosition(aData[1]);
            EventBus.dispatch(EventTypes.UpdateAbilities, [id, super.getPosition()]);
        }
    }

    public override function update():Void
    {
        asset.update();
    };
}