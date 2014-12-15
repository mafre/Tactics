package ability;

import flash.events.EventDispatcher;
import flash.display.Sprite;
import flash.geom.Point;
import flash.display.MovieClip;
import flash.utils.Object;

import event.DataEvent;
import common.StageInfo;
import event.EventType;
import event.EventBus;
import ability.Ability;
import tile.TileHelper;

class AbilityHandler
{
	static private var __instance:AbilityHandler;
    static public var dispatcher:EventDispatcher;

    private var abilities:Array<Ability>;

	public function new()
	{

	};

    public function init():Void
    {
        dispatcher = new EventDispatcher();
        abilities = [];
        EventBus.subscribe(EventTypes.GetValidAbilities, getValidAbilities);
        EventBus.subscribe(EventTypes.GetPositionsResult, getPositionsResult);
    }

    public function addAbility(aAbility:Ability):Void
    {
        aAbility.id = abilities.length;
        abilities.push(aAbility);
    }

    public function getAbility(aId:Int):Ability
    {
        for(ability in abilities)
        {
            if(ability.id == aId)
            {
                return ability;
            }
        }

        return null;
    }

    private function getValidAbilities(aData:Array<Dynamic>):Void
    {
        var userId:Int = aData[0];
        var characterId:Int = aData[1];
        var characterPos:Point = aData[2];

        var a:Array<Ability> = getCharactersAbilities(characterId);

        for(ability in a)
        {
            switch(ability.targetType)
            {
                case AbilityTargetType.Enemy:

                    var data:Array<Dynamic> = [ability.id, characterPos];
                    EventBus.dispatch(EventTypes.GetOpponentPositionsQuery, [userId, data]);

                case AbilityTargetType.Self:

                    EventBus.dispatch(EventTypes.UpdateAbility, [ability.id, true]);

                default:

            }
        }
    }

    private function getPositionsResult(aData:Array<Dynamic>):Void
    {
        var positions:Array<Point> = aData[0];
        var data:Array<Dynamic> = aData[1];
        var abilityId:Int = data[0];
        var characterPos:Point = data[1];
        var ability:Ability = getAbility(abilityId);
        var withinRange:Bool = false;

        for (position in positions)
        {
            var distance:Int = TileHelper.getDistanceBetweenPoint(characterPos, position);

            if(ability.range >= distance)
            {
                withinRange = true;
                break;
            }
        }

        EventBus.dispatch(EventTypes.UpdateAbility, [ability.id, withinRange]);
    }

    public function getCharactersAbilities(aCharacterId:Int):Array<Ability>
    {
        var a:Array<Ability> = [];

        for(ability in abilities)
        {
            if(ability.ownerId == aCharacterId)
            {
                a.push(ability);
            }
        }

        return a;
    }

    public function useAbility(aId:Int):Void
    {
        for(ability in abilities)
        {
            if(ability.id == aId)
            {
                dispatcher.dispatchEvent(new DataEvent(EventType.USE_ABILITY, ability));
            }
        }
    }

    public function addEventListener(type:String, listener:Dynamic):Void
    {
        dispatcher.addEventListener(type, listener);
    };

    public function removeEventListener(type:String, listener:Dynamic):Void
    {
        dispatcher.removeEventListener(type, listener);
    };

	public static function getInstance():AbilityHandler
    {
        if (AbilityHandler.__instance == null)
            AbilityHandler.__instance = new AbilityHandler();
        return AbilityHandler.__instance;
    };
}