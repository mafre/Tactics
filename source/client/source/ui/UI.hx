package ui;

import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;
import flash.geom.Point;

import common.StageInfo;
import ui.CharacterMenu;
import ui.Profile;

class UI extends Sprite
{
    private var characterMenu:CharacterMenu;
    private var profile:Profile;

	public function new()
	{
		super();

        characterMenu = new CharacterMenu();
        addChild(characterMenu);

        profile = new Profile();
        addChild(profile);
	};

    public function resize():Void
    {
        characterMenu.resize();
    };
}