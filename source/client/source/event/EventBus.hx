
package event;

import flash.utils.Object;
import flash.utils.Function;

import haxe.ds.StringMap;

enum EventTypes
{
    StartGame;
    MapsLoaded;
    SelectCharacter;
    DeselectCharacter;
    SetCharacterEnabled;
    TargetTileSelected;
    SelectAvatar;
    RoundComplete;
    NextRound;
    UpdateAdjacentEnemies;
    UpdateAbilities;
    UpdateAbilityIcon;
    UpdateCharacterPosition;
    UpdateCharacterDirection;
    CharacterDamaged;
    CharacterKilled;
    BackgroundClicked;
    UseAbility;
    UseAbilityGetCharacterPosition;
    UseAbilityGetTargetTiles;
    UseAbilityShowTargetTile;
    UseAbilityTargetTileSelected;
    UseAbilityApply;
    CancelAbility;
    ShowMoveTile;
    SetCharacterPosition;
    MoveCharacterToPosition;
    HideTargetTiles;
    UpdateCharacterMoves;
    EnemyKilled;
}

class EventBus
{
	private static var subscriptions:Array<Subscription>;

	public function new():Void
	{
        subscriptions = [];
	}

	public static function subscribe(aType:EventTypes, aSubscribedFunction:Function):Void
    {
        var subscription:Subscription = new Subscription(aType, aSubscribedFunction);
        subscriptions.push(subscription);
    }

    public static function unsubscribe(aType:EventTypes, aSubscribedFunction:Function):Void
    {
        for(subscription in subscriptions)
        {
            if(subscription.type == aType && subscription.subscribedFunction == aSubscribedFunction)
            {
                subscriptions.remove(subscription);
                return;
            }
        }
    }

    public static function dispatch(aType:EventTypes, ?aData:Dynamic):Void
    {
        for(subscription in subscriptions)
        {
            if(subscription.type == aType)
            {
                if(aData != null)
                {
                    subscription.subscribedFunction(aData);
                }
                else
                {
                    subscription.subscribedFunction();
                }
            }
        }
    }
}

class Subscription
{
    public var type:EventTypes;
    public var subscribedFunction:Function;

    public function new(aType:EventTypes, aSubscribedFunction:Function):Void
    {
        type = aType;
        subscribedFunction = aSubscribedFunction;
    }
}