package ui;

import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;
import flash.geom.Point;

import common.StageInfo;
import common.Image;
import event.EventType;
import utils.PositionHelper;
import ui.Avatar;
import character.CharacterView;
import character.CharacterModel;
import character.CharacterHandler;
import ui.Ability;
import ability.AbilityHandler;
import event.EventBus;
import common.LabelButton;

class CharacterMenu extends Sprite
{
    private var abilityContainer:Sprite;
    private var abilities:Array<Ability>;
    private var avatar:Avatar;
    private var health:Bar;
    private var moves:LabelButton;

	public function new()
	{
		super();

        abilityContainer = new Sprite();
        addChild(abilityContainer);

        abilities = [];

        health = new Bar();
        addChild(health);

        avatar = new Avatar();
        addChild(avatar);

        EventBus.subscribe(EventTypes.SelectCharacter, show);
        EventBus.subscribe(EventTypes.DeselectCharacter, hide);
        EventBus.subscribe(EventTypes.UpdateCharacterMoves, updateCharacterMoves);

        moves = new LabelButton("button1", "moves");
        addChild(moves);

        visible = false;
    };

    public function show(aData:Array<Dynamic>):Void
    {
        var characterModel:CharacterModel = CharacterHandler.getInstance().getCharacter(aData[0]);

        avatar.init(characterModel.id, characterModel.path);

        health.setPercent(characterModel.getHPPercent());

        updateCharacterMoves(characterModel.getMovesText());

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

        PositionHelper.alignHorizontally(abilities, new Point(0, 0) ,10);

        visible = true;
        resize();
    };

    private function updateCharacterMoves(aMovesText:String):Void
    {
        moves.setText(aMovesText);
    }

    public function hide():Void
    {
        for (ability in abilities)
        {
            ability.parent.removeChild(ability);
        }

        abilities = [];
        visible = false;
    }

    public function resize():Void
    {
        if(visible)
        {
            avatar.x = 10;
            avatar.y = StageInfo.stageHeight - avatar.height - 10;

            moves.x = avatar.x + avatar.width + 10;
            moves.y = avatar.y + avatar.height - moves.height;

            health.x = 10;
            health.y = avatar.y - health.height;

            abilityContainer.x = StageInfo.stageWidth - abilityContainer.width - 10;
            abilityContainer.y = StageInfo.stageHeight - abilityContainer.height - 10;
        }
    };
}