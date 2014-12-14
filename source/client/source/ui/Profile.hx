package ui;

import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;
import flash.geom.Point;
import flash.text.TextField;

import common.StageInfo;
import common.Image;
import common.GridSprite;
import event.EventType;
import event.EventBus;
import utils.SoundHandler;
import ui.Avatar;
import ui.Ability;
import utils.TextfieldFactory;
import utils.PositionHelper;
import ability.AbilityHandler;
import character.CharacterModel;
import character.CharacterHandler;
import common.Button;

class Profile extends Sprite
{
    private var modalBackground:GridSprite;
	private var abilityContainer:Sprite;
    private var abilities:Array<Ability>;
    private var avatar:Sprite;
    private var container:Sprite;
    private var nameTF:TextField;
    private var close:Button;

	public function new()
    {
        super();

        visible = false;

        container = new Sprite();
        addChild(container);

        modalBackground = new GridSprite("modal", 600, 400, true);
        container.addChild(modalBackground);

        abilityContainer = new Sprite();
        container.addChild(abilityContainer);

        abilities = [];

        nameTF = TextfieldFactory.getDefault();
        container.addChild(nameTF);

        close = new Button("img/close/close");
        container.addChild(close);
        close.scaleX = close.scaleY = StageInfo.scale;
        close.addEventListener(EventType.BUTTON_PRESSED, hide);

        EventBus.subscribe(EventTypes.SelectAvatar, show);
    };

    public function show(aId:Int):Void
    {
        visible = true;

        var characterModel:CharacterModel = CharacterHandler.getInstance().getCharacter(aId);

        avatar = new Image("img/avatar/"+characterModel.path+".png");
        avatar.scaleX = avatar.scaleY = StageInfo.scale;
        container.addChild(avatar);

        nameTF.text = characterModel.name;

        if(abilities.length != 0)
        {
            for(ability in abilities)
            {
                ability.parent.removeChild(ability);
            }
        }

        abilities = [];

        for (ability in AbilityHandler.getInstance().getCharactersAbilities(characterModel.id))
        {
            var abilityIcon:Ability = new Ability(ability.id, ability.abilityType, ability.targetType);
            abilityContainer.addChild(abilityIcon);
            abilities.push(abilityIcon);
        };

        PositionHelper.alignVertically(abilities, new Point(0, 0) ,10);

        resize();
    };

    public function hide(e:Event):Void
    {
        visible = false;

        avatar.parent.removeChild(avatar);

        for (ability in abilities)
        {
            ability.parent.removeChild(ability);
        }

        abilities = [];
    }

    public function resize():Void
    {
        if(visible)
        {
            PositionHelper.alignHorizontally([avatar, abilityContainer], new Point(30, 30), 20);
            nameTF.x = avatar.x + avatar.width/2 - nameTF.width/2;
            nameTF.y = avatar.y + avatar.height + 10;
            close.x = modalBackground.width - close.width - 30;
            close.y = 30;
            container.x = StageInfo.stageWidth/2 - container.width/2;
            container.y = StageInfo.stageHeight/2 - container.height/2;
        }
    };
}