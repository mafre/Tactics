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
import ui.AbilityResultInfo;
import motion.Actuate;

enum CharacterSelectState
{
    None;
    Move;
    AbilityTarget;
}

class CharacterView extends TileBase
{
    public var id:Int;
    private var asset:Animation;
    private var enabled:Sprite;
    private var state:CharacterSelectState;

	public function new(aId:Int, aPath:String)
	{
        super();

        type = EntityType.CHARACTER;
        layer = 3;
        id = aId;
        state = CharacterSelectState.None;

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

        EventBus.subscribe(EventTypes.CheckIfPositionIsAbilityTarget, checkIfPositionIsAbilityTarget);
        EventBus.subscribe(EventTypes.MoveCharacterToPosition, moveToPosition);
        EventBus.subscribe(EventTypes.SetCharacterEnabled, setEnabled);
        EventBus.subscribe(EventTypes.ShowAbilityResultInfo, showAbilityResultInfo);
        EventBus.subscribe(EventTypes.Defeated, defeated);

        addEventListener(MouseEvent.CLICK, characterClicked);
	};

    private function characterClicked(e:MouseEvent):Void
    {
        switch (state)
        {
            case CharacterSelectState.None:

            case CharacterSelectState.Move:

                selectCharacter(id);

            case CharacterSelectState.AbilityTarget:

                EventBus.dispatch(EventTypes.TargetSelected, super.getPosition());

                if(enabled.visible)
                {
                    state = CharacterSelectState.Move;
                }
                else
                {
                    state = CharacterSelectState.None;
                }
        }
    }

    private function selectCharacter(aId:Int):Void
    {
        if(id == aId)
        {
            EventBus.dispatch(EventTypes.DeselectCharacter);
            EventBus.dispatch(EventTypes.SelectCharacter, [id, super.getPosition()]);
        }
    }

    private function checkIfPositionIsAbilityTarget(aPosition:Point):Void
    {
        if (super.getPosition().x == aPosition.x && super.getPosition().y == aPosition.y)
        {
            state = CharacterSelectState.AbilityTarget;
        }
    }

    private function setEnabled(aData:Array<Dynamic>):Void
    {
        if(id == aData[0])
        {
            var isEnabled:Bool = aData[1];

            enabled.visible = isEnabled;

            if(!isEnabled)
            {
                state = CharacterSelectState.None;
            }
            else
            {
                state = CharacterSelectState.Move;
            }
        }
    }

    private function showAbilityResultInfo(aData:Array<Dynamic>):Void
    {
        var targetId:Int = aData[0];
        var aLabel:String = aData[1];

        if(id == targetId)
        {
            var info:AbilityResultInfo = new AbilityResultInfo(aLabel, asset.width);

            info.x = x;
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

    private function moveToPosition(aData:Array<Dynamic>):Void
    {
        var aId:Int = aData[0];
        var path:Array<Point> = aData[1];

        if(aId == id)
        {
            for (i in 0...path.length)
            {
                Actuate.timer(0.3*i).onComplete(function()
                {
                    setPosition(path[i]);
                });
            }
        }
    }

    public override function update():Void
    {
        asset.update();
    };
}