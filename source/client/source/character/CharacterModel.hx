package character;

import flash.utils.Function;
import flash.geom.Point;
import event.EventBus;
import tile.TileHelper;
import ability.Ability;
import ability.AbilityHandler;

import event.EventType;

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

enum CharacterType
{
	Banshee;
	Blacksmith;
	Berserk;
	Priest;
	Rogue;
	Knight;
	Monk;
	Thief;
	Druid;
	RuneMage;
}

class CharacterModel
{
    public var id:Int;
	private var hp:Int;
	private var sp:Int;
	private var xp:Int;
	private var str:Int;
	private var vit:Int;
	private var dex:Int;
	private var agi:Int;
	private var int:Int;
	private var luk:Int;
	private var lvl:Int;
    private var mov:Int;
    private var abi:Int;
    private var pos:Point;
    public var userId:String;
    public var name:String;
    public var path:String;
    public var type:CharacterType;
    public var direction:Direction;
    public var state:CharacterState;
    public var enabled:Bool;

	public function new(aUserId:String, aType:CharacterType)
	{
		str = 1;
		vit = 1;
		dex = 1;
		agi = 1;
		int = 1;
		luk = 1;

		userId = aUserId;
        type = aType;

        state = CharacterState.Idle;
        direction = Direction.Down;

		switch(type)
        {
            case CharacterType.Banshee:

                name = "Hrafninn";
                path = "banshee";

            case CharacterType.Blacksmith:

                name = "Baldur";
                path = "blacksmith";

            case CharacterType.Berserk:

                name = "Ljotur";
                path = "berserk";

            case CharacterType.Priest:

                name = "Fridrik";
                path = "priest";

            case CharacterType.Rogue:

                name = "Fantur";
                path = "rogue";

            case CharacterType.Knight:

                name = "Trausti";
                path = "knight";

            case CharacterType.Monk:

                name = "Tungur";
                path = "monk";

            case CharacterType.Thief:

                name = "Tjofur";
                path = "thief";

            case CharacterType.Druid:

                name = "Ulfur";
                path = "druid";

            case CharacterType.RuneMage:

                name = "Tyr";
                path = "runemage";
        }

        setLevel(1);

        EventBus.subscribe(EventTypes.SelectCharacter, selectCharacter);
        EventBus.subscribe(EventTypes.DeselectCharacter, deselectCharacter);
        EventBus.subscribe(EventTypes.SetCharacterPosition, setPosition);
        EventBus.subscribe(EventTypes.UseAbility, useAbility);
        EventBus.subscribe(EventTypes.UseAbilityGetCharacterPosition, useAbilityGetCharacterPosition);
	};

    public function setEnabled(aEnabled:Bool):Void
    {
        enabled = aEnabled;
    }

    public function newRound():Void
    {
        abi = 1;
        resetMoveCount();
    }

    private function useAbilityGetCharacterPosition(aData:Array<Dynamic>):Void
    {
        if(id == aData[0])
        {
            EventBus.dispatch(EventTypes.UseAbilityGetTargetTiles, [pos, aData[1]]);
        }
    }

    private function selectCharacter(aData:Array<Dynamic>):Void
    {
        if(aData[0] == id)
        {
            EventBus.subscribe(EventTypes.TargetTileSelected, positionSelected);
        }
    }

    private function deselectCharacter():Void
    {
        EventBus.unsubscribe(EventTypes.TargetTileSelected, positionSelected);
    }

    public function initPosition(aPosition:Point):Void
    {
        pos = aPosition;
    }

    private function positionSelected(aPosition:Point):Void
    {
        EventBus.unsubscribe(EventTypes.TargetTileSelected, positionSelected);
        EventBus.dispatch(EventTypes.SetCharacterPosition, [id, aPosition]);
    }

    private function setPosition(aData:Array<Dynamic>):Void
    {
        if(aData[0] == id)
        {
            var newPos:Point = aData[1];
            var distance:Int = TileHelper.getDistanceBetweenPoint(pos, newPos);
            mov -= distance;
            EventBus.dispatch(EventTypes.UpdateCharacterMoves, getMovesText());

            pos = newPos;

            EventBus.dispatch(EventTypes.MoveCharacterToPosition, [id, pos]);
            EventBus.unsubscribe(EventTypes.TargetTileSelected, setPosition);
        }
    }

    private function useAbility(aId:Int):Void
    {
        EventBus.unsubscribe(EventTypes.TargetTileSelected, positionSelected);
    }

	public function setLevel(aLevel:Int):Void
	{
		lvl = aLevel;
		hp = Std.int(getMaxHP());
		sp = Std.int(getMaxSP());
	}

	public function addXP(aXp:Int):Void
	{
		xp += aXp;

		var currentLevel:Int = Math.floor(Math.sqrt(xp)*0.1)+1;

		if(lvl != currentLevel)
		{
			levelUp(currentLevel);
		}
	}

	public function levelUp(aLevel:Int):Void
	{
		lvl = aLevel;
	}

	public function getMaxHP():Int
	{
		return Math.floor(10*lvl*Math.pow(1.01, vit));
	}

	public function getMaxSP():Int
	{
		return Math.floor(10+lvl*Math.pow(1.01, int));
	}

    public function resetMoveCount():Void
    {
        mov = getMaxMoves();
    }

    public function getMaxMoves():Int
    {
        return 10 + Math.floor(agi/15);
    }

    public function getMoves():Int
    {
        return mov;
    }

    public function move(aDistance:Int):Void
    {
        mov -= aDistance;
    }

    public function getMovesText():String
    {
        return mov + "/" + getMaxMoves();
    }

	public function getAtk():Int
	{
		return str;
	}

	public function getMAtk():Float
	{
		return int*Math.pow((int/10), 2);
	}

	public function getDef():Float
	{
		return 0;
	}

	public function getCrit():Float
	{
		return luk*0.3+1;
	}

	public function getFlee():Float
	{
		return lvl+agi;
	}

	public function getAccuracy(flee:Float):Float
	{
		return 80+lvl+dex-flee;
	}

	public function getASpd():Float
	{
		return 1+(agi+dex/4)/10;
	}

	public function getAttackCooldown():Int
	{
		return Std.int(10+60/Math.pow(getASpd(),2));
	}

	public function getHPRegenAmount():Float
	{
		return lvl+vit/5;
	}

	public function getHPRegenCooldown():Float
	{
		return Math.floor(150+(300-(vit/99)*300));
	}

	public function getSPRegenAmount():Float
	{
		return lvl+vit/6;
	}

	public function getSPRegenCooldown():Float
	{
		return Math.floor(150+(300-(int/99)*300));
	}

    public function getHPPercent():Float
    {
        return hp/getMaxHP();
    }

    public function getAssetPath():String
    {
        var assetPath:String = "img/character/" + path + "/";

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