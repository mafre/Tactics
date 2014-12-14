package event;

class EventType
{
	static public inline var BUTTON_PRESSED:String					= "ButtonPressed";
	static public inline var BUTTON_RELEASED:String					= "ButtonReleased";

	static public inline var SLIDER_MOVE:String						= "SliderMove";
	static public inline var SLIDER_CHANGED:String					= "SliderChanged";

	static public inline var STAGE_RESIZED:String					= "stageResized";
	static public inline var STAGE_INITIALIZED:String				= "stageInitialized";

    static public inline var LEVELS_LOADED:String                   = "levelsLoaded";

    static public inline var USE_ABILITY:String                     = "UseAbility";
    static public inline var CANCEL_ABILITY:String                  = "CancelAbility";

    static public inline var AVATAR_CLICKED:String                  = "AvatarClicked";

    static public inline var CHARACTER_CLICKED:String               = "CharacterClicked";
    static public inline var ENEMY_CLICKED:String                   = "EnemyClicked";
    static public inline var BACKGROUND_TILE_CLICKED:String         = "BackgroundTileClicked";
    static public inline var TARGET_TILE_CLICKED:String             = "TargetTileClicked";

    static public inline var ANIMATION_UPDATE:String                = "AnimationUpdate";
    static public inline var ANIMATION_EVENT:String                 = "AnimationEvent";
    static public inline var ANIMATION_COMPLETE:String              = "AnimationComplete";
}