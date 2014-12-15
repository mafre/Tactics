package character;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.geom.Point;

import ability.Ability;
import ability.AbilityType;
import entity.Entity;
import entity.EntityType;
import entity.EntityHandler;
import common.Animation;
import common.GridSprite;
import common.Image;
import event.EventType;
import event.EventBus;
import utils.SoundHandler;
import tile.TileBase;
import tile.TileHelper;
import ui.AttackResultInfo;

class CharacterView extends TileBase
{
    public var id:Int;
    private var asset:Animation;
    private var enabled:Sprite;

	public function new(aId:Int, aPath:String)
	{
        super();

        type = EntityType.CHARACTER;
        layer = 3;
        id = aId;

        enabled = new Image("img/user/enabled.png");
        addChild(enabled);
        enabled.visible = false;

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
        EventBus.subscribe(EventTypes.ShowDamage, showDamage);
        EventBus.subscribe(EventTypes.ShowBlocked, showBlocked);
        EventBus.subscribe(EventTypes.Defeated, defeated);
	};

    private function setEnabled(aData:Array<Dynamic>):Void
    {
        if(id == aData[0])
        {
            var isEnabled:Bool = aData[1];

            enabled.visible = isEnabled;

            if(isEnabled)
            {
                addEventListener(MouseEvent.CLICK, characterClicked);
            }
            else
            {
                removeEventListener(MouseEvent.CLICK, characterClicked);
            }
        }
    }

    private function showDamage(aData:Array<Dynamic>):Void
    {
        var targetId:Int = aData[0];
        var value:Int = aData[1];

        if(id == targetId)
        {
            var info:AttackResultInfo = new AttackResultInfo(Std.string(value));

            info.x = x + asset.width/2 - info.width/2;
            info.y = y - asset.height - 3;

            EntityHandler.getInstance().addEntity(info);
        }
    }

    private function showBlocked(targetId:Int):Void
    {
        if(id == targetId)
        {
            var info:AttackResultInfo = new AttackResultInfo("Blocked");

            info.x = x + asset.width/2 - info.width/2;
            info.y = y - asset.height - 3;

            EntityHandler.getInstance().addEntity(info);
        }
    }

    private function defeated(aData:Array<Dynamic>):Void
    {
        var targetId:Int = aData[0];

        if(id == targetId)
        {
            super.remove();
        }
    }


    private function characterClicked(e:MouseEvent):Void
    {
        selectCharacter(id);
    }

    private function selectCharacter(aId:Int):Void
    {
        if(id == aId)
        {
            EventBus.dispatch(EventTypes.DeselectCharacter);
            EventBus.dispatch(EventTypes.SetActiveCharacter, [id, super.getPosition()]);
        }
    }

    private function moveToPosition(aData:Array<Dynamic>):Void
    {
        var aId:Int = aData[0];
        var aPos:Point = aData[1];

        if(id == aId)
        {
            super.setPosition(aPos);
        }
    }

    public override function update():Void
    {
        asset.update();
    };
}