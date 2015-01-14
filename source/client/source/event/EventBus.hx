
package event;

import flash.utils.Object;

import haxe.ds.StringMap;

enum EventTypes
{
    MapsLoaded;
    SetActiveCharacter;
    CharacterInitialized;
    SelectCharacter;
    DeselectCharacter;
    SetCharacterEnabled;
    ShowNextUser;
    TargetSelected;
    SelectAvatar;
    EndTurn;
    NextTurn;
    UpdateAbilities;
    UpdateAbility;
    CheckIfPositionIsAbilityTarget;
    SetAbilityTarget;
    UpdateCharacterPosition;
    UpdateCharacterDirection;
    DealDamage;
    TakeDamage;
    Defeated;
    BackgroundClicked;
    SelectCharacterWithId;
    SelectOwnerOfAbility;
    GetAbilityTargets;
    GetAbilityTargetsCheckOwnerPos;
    GetAbilityTargetsCheckTiles;
    ShowAbilityTargets;
    UseAbility;
    UseAbilityTargetTileSelected;
    UseAbilityApply;
    CancelAbility;
    DisableAbilities;
    GetValidAbilities;
    GetOpponentPositionsQuery;
    GetAllyPositionsQuery;
    GetAbilityPositionsResult;
    ShowTargetTileWithId;
    ShowTargetTileWithPosition;
    SetCharacterPosition;
    MoveCharacterToPosition;
    UpdateCharacterMoves;
    GetPath;
    HideTargetTiles;
    ShowAbilityResultInfo;
    Guard;
    Taunted;
    AbilityUsed;
    UserWon;
    ResetGame;
}

class EventBus
{
	private static var subscriptions:Array<Subscription>;

	public function new():Void
	{
        subscriptions = [];
	}

	public static function subscribe(aType:EventTypes, aSubscribedFunction:Dynamic):Void
    {
        var subscription:Subscription = new Subscription(aType, aSubscribedFunction);
        subscriptions.push(subscription);
    }

    public static function unsubscribe(aType:EventTypes, aSubscribedFunction:Dynamic):Void
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
    public var subscribedFunction:Dynamic;

    public function new(aType:EventTypes, aSubscribedFunction:Dynamic):Void
    {
        type = aType;
        subscribedFunction = aSubscribedFunction;
    }
}