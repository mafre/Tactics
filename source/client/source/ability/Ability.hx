package ability;

import flash.geom.Point;
import event.EventBus;
import entity.EntityType;
import enemy.Enemy;
import character.CharacterHandler;
import character.CharacterModel;
import ability.AbilityType;
import tile.TileHelper;

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
    public var validPositions:Array<Point>;

	public function new(aOwnerId:Int, aAbilityType:String, ?aRange:Int, ?aTargetType:AbilityTargetType)
	{
        ownerId = aOwnerId;
        abilityType = aAbilityType;
        enabled = false;
        validPositions = [];

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
        EventBus.subscribe(EventTypes.CancelAbility, cancelAbility);
        EventBus.subscribe(EventTypes.DeselectCharacter, cancelAbility);
        EventBus.subscribe(EventTypes.UseAbilityApply, apply);
        EventBus.subscribe(EventTypes.GetAbilityPositionsResult, getAbilityPositionsResult);
	};

    private function useAbility(aId:Int):Void
    {
        if(id == aId)
        {
            EventBus.subscribe(EventTypes.TargetSelected, targetSelected);
            EventBus.subscribe(EventTypes.CancelAbility, cancelAbility);

            for (pos in validPositions)
            {
                EventBus.dispatch(EventTypes.CheckIfPositionIsAbilityTarget, pos);
            }
        }
    }

    private function getAbilityPositionsResult(aData:Array<Dynamic>):Void
    {
        var positions:Array<Point> = aData[0];
        var data:Array<Dynamic> = aData[1];
        var abilityId:Int = data[0];
        var characterPos:Point = data[1];

        if(abilityId == id)
        {
            validPositions = [];

            var withinRange:Bool = false;

            for (position in positions)
            {
                var distance:Int = TileHelper.getDistanceBetweenPoint(characterPos, position);

                if(range >= distance)
                {
                    withinRange = true;
                    validPositions.push(position);
                }
            }

            EventBus.dispatch(EventTypes.UpdateAbility, [id, withinRange]);
        }
    }

    private function targetSelected(aPosition:Point):Void
    {
        EventBus.unsubscribe(EventTypes.CancelAbility, cancelAbility);
        EventBus.unsubscribe(EventTypes.TargetSelected, targetSelected);
        EventBus.dispatch(EventTypes.UseAbilityTargetTileSelected, [id, aPosition]);
    }

    private function cancelAbility():Void
    {
        EventBus.unsubscribe(EventTypes.TargetSelected, targetSelected);
        EventBus.unsubscribe(EventTypes.CancelAbility, cancelAbility);
    }

    private function apply(aData:Array<Dynamic>):Void
    {
        if(aData[0] == id)
        {
            EventBus.dispatch(EventTypes.AbilityUsed, ownerId);

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

                        case AbilityType.HAMMER:

                            EventBus.dispatch(EventTypes.DealDamage, [ownerId, targetId]);

                        case AbilityType.TAUNT:

                            EventBus.dispatch(EventTypes.Taunted, [ownerId, targetId]);

                        default:
                    }

                case AbilityTargetType.Self:

                    switch(abilityType)
                    {
                        case AbilityType.SHIELD:

                            EventBus.dispatch(EventTypes.Guard, ownerId);

                        default:
                    }

                case AbilityTargetType.Ally:

                case AbilityTargetType.AllEnemies:

                case AbilityTargetType.AllAllies:
            }
        }
    }
}