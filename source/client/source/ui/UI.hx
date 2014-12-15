package ui;

import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;
import flash.geom.Point;

import common.StageInfo;
import common.Button;
import ui.CharacterMenu;
import ui.Profile;
import ui.NextTurn;
import ui.UserWon;
import event.EventType;
import event.EventBus;

class UI extends Sprite
{
    private var characterMenu:CharacterMenu;
    private var profile:Profile;
    private var endTurn:Button;
    private var nextTurn:NextTurn;
    private var userWon:UserWon;

	public function new()
	{
		super();

        characterMenu = new CharacterMenu();
        addChild(characterMenu);

        profile = new Profile();
        addChild(profile);

        endTurn = new Button("img/endTurn/endTurn");
        addChild(endTurn);
        endTurn.scaleX = endTurn.scaleY = StageInfo.scale;
        endTurn.addEventListener(EventType.BUTTON_PRESSED, endTurnPressed);

        nextTurn = new NextTurn();
        addChild(nextTurn);

        userWon = new UserWon();
        addChild(userWon);
	};

    private function endTurnPressed(e:Event):Void
    {
        EventBus.dispatch(EventTypes.EndTurn);
    }

    public function resize():Void
    {
        characterMenu.resize();

        endTurn.x = StageInfo.stageWidth - endTurn.width - 10;
        endTurn.y = 10;
    };
}