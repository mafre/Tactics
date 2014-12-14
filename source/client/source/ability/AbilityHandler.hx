package ability;

import flash.events.EventDispatcher;
import flash.display.Sprite;
import flash.geom.Point;
import flash.display.MovieClip;
import flash.utils.Object;
import flash.utils.Function;

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
        EventBus.subscribe(EventTypes.UpdateAbilities, updateAbilities);
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

    public function updateAbilities(aData:Array<Dynamic>):Void
    {
        var ownerId:Int = aData[0];
        var ownerPosition:Point = aData[1];
        var positions:Array<Point> = aData[2];

        for (ability in abilities)
        {
            ability.enabled = false;
        }

        for (ability in abilities)
        {
            if(ability.ownerId == ownerId)
            {
                if(ability.targetType == AbilityTargetType.Self)
                {
                    ability.enabled = true;
                }

                if(ability.targetType == AbilityTargetType.Enemy)
                {
                    for (position in positions)
                    {
                        var distance:Int = TileHelper.getDistanceBetweenPoint(ownerPosition, position);

                        if(ability.range >= distance)
                        {
                            ability.enabled = true;
                        }
                    }
                }
            }
        }

        for (ability in abilities)
        {
            EventBus.dispatch(EventTypes.UpdateAbility, [ability.id, ability.enabled]);
        }
    }

    public function addEventListener(type:String, listener:Function):Void
    {
        dispatcher.addEventListener(type, listener);
    };

    public function removeEventListener(type:String, listener:Function):Void
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