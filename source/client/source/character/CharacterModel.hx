package character;

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
    private var guard:Bool;

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
                str = 10;
                vit = 20;

            case CharacterType.Berserk:

                name = "Ljotur";
                path = "berserk";
                str = 15;
                vit = 15;

            case CharacterType.Priest:

                name = "Fridrik";
                path = "priest";

            case CharacterType.Rogue:

                name = "Fantur";
                path = "rogue";
                agi = 20;
                str = 10;

            case CharacterType.Knight:

                name = "Trausti";
                path = "knight";
                str = 10;
                vit = 15;
                agi = 10;

            case CharacterType.Monk:

                name = "Tungur";
                path = "monk";

            case CharacterType.Thief:

                name = "Tjofur";
                path = "thief";
                agi = 30;
                str = 10;
                vit = 10;

            case CharacterType.Druid:

                name = "Ulfur";
                path = "druid";

            case CharacterType.RuneMage:

                name = "Tyr";
                path = "runemage";
        }

        setLevel(1);

        EventBus.subscribe(EventTypes.SetActiveCharacter, setActiveCharacter);
        EventBus.subscribe(EventTypes.CharacterInitialized, characterInitialized);
        EventBus.subscribe(EventTypes.DeselectCharacter, deselectCharacter);
        EventBus.subscribe(EventTypes.SetCharacterPosition, setPosition);
        EventBus.subscribe(EventTypes.MoveCharacterToPosition, moveCharacterToPosition);
        EventBus.subscribe(EventTypes.UseAbility, useAbility);
        EventBus.subscribe(EventTypes.DealDamage, dealDamage);
        EventBus.subscribe(EventTypes.TakeDamage, takeDamage);
        EventBus.subscribe(EventTypes.AbilityUsed, abilityUsed);
        EventBus.subscribe(EventTypes.UpdateAbilities, updateAbilities);
        EventBus.subscribe(EventTypes.Guard, guarding);
        EventBus.subscribe(EventTypes.Taunted, taunted);
	};

    public function setEnabled(aEnabled:Bool):Void
    {
        enabled = aEnabled;
        EventBus.dispatch(EventTypes.SetCharacterEnabled, [id, enabled]);
    }

    public function reset():Void
    {
        abi = 1;
        resetMoveCount();
        guard = false;
    }

    private function abilityUsed(aCharacterId:Int):Void
    {
        if(id == aCharacterId)
        {
            abi--;

            if(abi == 0)
            {
                EventBus.dispatch(EventTypes.DisableAbilities);
            }
        }
    }

    private function guarding(aId:Int):Void
    {
        if(id == aId)
        {
            guard = true;
            mov = 0;
            abi = 0;
            EventBus.dispatch(EventTypes.UpdateCharacterMoves, getMovesText());
            EventBus.dispatch(EventTypes.ShowAbilityResultInfo, [id, "Guarding"]);
        }
    }

    private function taunted(aData:Array<Dynamic>):Void
    {
        var sourceId:Int = aData[9];
        var sourceId:Int = aData[1];

        if(id == sourceId)
        {
            EventBus.dispatch(EventTypes.ShowAbilityResultInfo, [id, "Angry"]);
        }
    }

    private function setActiveCharacter(aData:Array<Dynamic>):Void
    {
        if(aData[0] == id)
        {
            EventBus.subscribe(EventTypes.TargetSelected, positionSelected);
        }
    }

    private function characterInitialized(aId:Int):Void
    {
        if(id == aId)
        {
            EventBus.dispatch(EventTypes.SetActiveCharacter, [id, pos, mov, abi]);

            updateAbilities(id);
        }
    }

    private function updateAbilities(aId):Void
    {
        if(id == aId)
        {
            if(abi == 0)
            {
                EventBus.dispatch(EventTypes.DisableAbilities);
            }
            else
            {
                EventBus.dispatch(EventTypes.GetValidAbilities, [userId, id, pos]);
            }
        }
    }

    private function deselectCharacter():Void
    {
        EventBus.unsubscribe(EventTypes.TargetSelected, positionSelected);
    }

    public function initPosition(aPosition:Point):Void
    {
        pos = aPosition;
    }

    private function positionSelected(aPosition:Point):Void
    {
        EventBus.unsubscribe(EventTypes.TargetSelected, positionSelected);
        EventBus.dispatch(EventTypes.SetCharacterPosition, [id, aPosition]);
    }

    private function setPosition(aData:Array<Dynamic>):Void
    {
        var aId:Int = aData[0];

        if(aId == id)
        {
            var newPos:Point = aData[1];

            EventBus.dispatch(EventTypes.GetPath, [id, pos, newPos]);

            pos = newPos;

            EventBus.unsubscribe(EventTypes.TargetSelected, setPosition);

            updateAbilities(id);
        }
    }

    private function moveCharacterToPosition(aData:Array<Dynamic>):Void
    {
        var aId:Int = aData[0];

        if(aId == id)
        {
            var path:Array<Point> = aData[1];

            mov -= (path.length-1);

            EventBus.dispatch(EventTypes.UpdateCharacterMoves, getMovesText());
        }
    }

    public function getPosition():Point
    {
        return pos;
    }

    private function useAbility(aId:Int):Void
    {
        EventBus.unsubscribe(EventTypes.TargetSelected, positionSelected);
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

    private function dealDamage(aData:Array<Dynamic>):Void
    {
        var damageDealerId:Int = aData[0];
        var targetId:Int = aData[1];

        if(id == damageDealerId)
        {
            EventBus.dispatch(EventTypes.TakeDamage, [id, targetId, getAtk()]);
        }
    }

    public function takeDamage(aData:Array<Dynamic>):Void
    {
        var damageDealerId:Int = aData[9];
        var targetId:Int = aData[1];
        var damage:Int = aData[2];

        if(id == targetId)
        {
            if(guard)
            {
                EventBus.dispatch(EventTypes.ShowAbilityResultInfo, [id, "Blocked"]);
                return;
            }

            hp -= damage;

            EventBus.dispatch(EventTypes.ShowAbilityResultInfo, [id, "-"+Std.string(damage)]);

            if(hp <= 0)
            {
                EventBus.dispatch(EventTypes.Defeated, [id, damageDealerId]);
            }
        }
    }

    public function resetMoveCount():Void
    {
        mov = getMaxMoves();
    }

    public function getMaxMoves():Int
    {
        return 3 + Math.floor(agi/10);
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