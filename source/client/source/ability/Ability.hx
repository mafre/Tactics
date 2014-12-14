package ability;

import flash.geom.Point;
import event.EventBus;
import entity.EntityHandler;
import entity.Entity;
import entity.EntityType;
import enemy.Enemy;
import character.CharacterHandler;
import character.CharacterModel;

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
    public var characterId:Int;
    public var abilityType:String;
    public var range:Int;
    public var enabled:Bool;
    public var targetType:AbilityTargetType;

	public function new(aCharacterId:Int, aAbilityType:String, ?aRange:Int, ?aTargetType:AbilityTargetType)
	{
        characterId = aCharacterId;
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
            EventBus.dispatch(EventTypes.UseAbilityGetCharacterPosition, [characterId, range]);
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
            var character:CharacterModel = CharacterHandler.getInstance().getCharacter(characterId);
            var targetId:Int = aData[1];

            switch(targetType)
            {
                case AbilityTargetType.Enemy:

                    for (entity in EntityHandler.getInstance().getEntities())
                    {
                        if(entity.type == EntityType.ENEMY)
                        {
                            var enemy:Enemy = cast(entity, Enemy);

                            if(enemy.id == targetId)
                            {
                                enemy.takeDamage(character.getAtk(), characterId);
                            }
                        }
                    }

                    for(character in CharacterHandler.getInstance().getAllCharacters())
                    {
                        if(character.id == targetId)
                        {
                            character.takeDamage(character.getAtk(), characterId);
                        }
                    }

                case AbilityTargetType.Self:

                case AbilityTargetType.Ally:

                case AbilityTargetType.AllEnemies:

                case AbilityTargetType.AllAllies:
            }
        }
    }
}