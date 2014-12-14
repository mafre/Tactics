package ability;

import flash.geom.Point;
import event.EventBus;
import entity.EntityType;
import enemy.Enemy;
import character.CharacterHandler;
import character.CharacterModel;
import ability.AbilityType;

enum AbilityTargetType
{
    Self;
    Enemy;
    AllEnemies;
    Ally;
    AllAllies;
}

class Ability
{
	public var id:Int;
    public var ownerId:Int;
    public var abilityType:String;
    public var range:Int;
    public var enabled:Bool;
    public var targetType:AbilityTargetType;

	public function new(aOwnerId:Int, aAbilityType:String, ?aRange:Int, ?aTargetType:AbilityTargetType)
	{
        ownerId = aOwnerId;
        abilityType = aAbilityType;
        enabled = false;

        if(aRange != null)
        {
            range = aRange;
        }
        else
        {
            range = 0;
        }

        if(aTargetType != null)
        {
            targetType = aTargetType;
        }
        else
        {
            targetType = AbilityTargetType.Enemy;
        }

        EventBus.subscribe(EventTypes.UseAbility, useAbility);
        EventBus.subscribe(EventTypes.UseAbilityApply, apply);
	};

    private function useAbility(aId:Int):Void
    {
        if(id == aId)
        {
            EventBus.subscribe(EventTypes.TargetTileSelected, targetTileSelected);
            EventBus.subscribe(EventTypes.CancelAbility, cancelAbility);
            EventBus.dispatch(EventTypes.UseAbilityGetCharacterPosition, [ownerId, range]);
        }
    }

    private function targetTileSelected(aPosition:Point):Void
    {
        EventBus.unsubscribe(EventTypes.TargetTileSelected, targetTileSelected);
        EventBus.dispatch(EventTypes.UseAbilityTargetTileSelected, [id, aPosition]);
    }

    private function cancelAbility():Void
    {
        EventBus.unsubscribe(EventTypes.TargetTileSelected, targetTileSelected);
        EventBus.unsubscribe(EventTypes.CancelAbility, cancelAbility);
    }

    private function apply(aData:Array<Dynamic>):Void
    {
        if(aData[0] == id)
        {
            var targetId:Int = aData[1];

            switch(targetType)
            {
                case AbilityTargetType.Enemy:

                    switch(abilityType)
                    {
                        case AbilityType.SWORD:

                            EventBus.dispatch(EventTypes.DealDamage, [ownerId, targetId]);

                        case AbilityType.KNIFE:

                            EventBus.dispatch(EventTypes.DealDamage, [ownerId, targetId]);

                        case AbilityType.FIST:

                            EventBus.dispatch(EventTypes.DealDamage, [ownerId, targetId]);

                        case AbilityType.STAFF:

                            EventBus.dispatch(EventTypes.DealDamage, [ownerId, targetId]);

                        case AbilityType.BOW:

                            EventBus.dispatch(EventTypes.DealDamage, [ownerId, targetId]);

                        case AbilityType.TAUNT:

                        default:
                    }

                case AbilityTargetType.Self:

                case AbilityTargetType.Ally:

                case AbilityTargetType.AllEnemies:

                case AbilityTargetType.AllAllies:
            }
        }
    }
}