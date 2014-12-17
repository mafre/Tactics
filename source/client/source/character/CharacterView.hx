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

enum Direction
{
    Up;
    Right;
    Down;
    Left;
}

enum CharacterState
{
    Idle;
    Walk;
    Attack;
}

class CharacterView extends TileBase
{
    public var id:Int;
    private var asset:Animation;
    private var enabled:Sprite;
    private var selectState:CharacterSelectState;
    public var direction:Direction;
    public var state:CharacterState;

	public function new(aId:Int)
	{
        super();

        type = EntityType.CHARACTER;
        layer = 3;
        id = aId;
        selectState = CharacterSelectState.None;
        state = CharacterState.Idle;
        direction = Direction.Down;

        enabled = new Image("img/user/enabled.png");
        addChild(enabled);
        enabled.visible = false;

        asset = new Animation(true);
        asset.setFrames([1, 2]);
        asset.setDelay(12);
        asset.setPath(getAssetPath());
        addChild(asset);
        asset.start();
        asset.x = TileHelper.tileWidth - asset.width/2;
        asset.y = TileHelper.tileHeight*1.5 - asset.height;

        EventBus.subscribe(EventTypes.CheckIfPositionIsAbilityTarget, checkIfPositionIsAbilityTarget);
        EventBus.subscribe(EventTypes.MoveCharacterToPosition, moveToPosition);
        EventBus.subscribe(EventTypes.SetCharacterEnabled, setEnabled);
        EventBus.subscribe(EventTypes.ShowAbilityResultInfo, showAbilityResultInfo);
        EventBus.subscribe(EventTypes.Defeated, defeated);

        addEventListener(MouseEvent.CLICK, characterClicked);
	};

    private function characterClicked(e:MouseEvent):Void
    {
        switch (selectState)
        {
            case CharacterSelectState.None:

            case CharacterSelectState.Move:

                selectCharacter(id);

            case CharacterSelectState.AbilityTarget:

                EventBus.dispatch(EventTypes.TargetSelected, super.getPosition());

                if(enabled.visible)
                {
                    selectState = CharacterSelectState.Move;
                }
                else
                {
                    selectState = CharacterSelectState.None;
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
            selectState = CharacterSelectState.AbilityTarget;
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
                selectState = CharacterSelectState.None;
            }
            else
            {
                selectState = CharacterSelectState.Move;
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

                    if(i != 0)
                    {
                        direction = TileHelper.getDirection(path[i-1], path[i]);
                        asset.setPath(getAssetPath());
                    }
                });
            }
        }
    }

    public override function update():Void
    {
        asset.update();
    };

    public function getAssetPath():String
    {
        //var assetPath:String = "img/character/" + path + "/";

        var assetPath:String = "img/character/default/";

        switch (state)
        {
            case CharacterState.Idle:

                assetPath += "idle/";

            case CharacterState.Walk:

                assetPath += "walk/";

            case CharacterState.Attack:

                assetPath += "attack/";
        }

        switch (direction)
        {
            case Direction.Up:

                assetPath += "up";

            case Direction.Right:

                assetPath += "right";

            case Direction.Down:

                assetPath += "down";

            case Direction.Left:

                assetPath += "left";
        }

        return assetPath;
    }
}