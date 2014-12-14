package state;

import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.geom.Point;

import utils.SoundHandler;
import utils.TextfieldFactory;
import utils.PositionHelper;
import utils.SWFHandler;
import connection.ConnectionHandler;
import user.UserHandler;
import common.StageInfo;
import common.GridSprite;
import common.Button;
import common.LabelButton;
import common.ToggleButton;
import event.EventType;
import common.Image;
import common.Slider;
import state.StateHandler;

class Start extends State
{
	private var header:TextField;
	private var modalBackground:GridSprite;
	private var loginButton:LabelButton;
	private var createAccountButton:LabelButton;

	public function new():Void
	{
		super();

		modalBackground = new GridSprite("modal", 400, 300, true);
		container.addChild(modalBackground);

		header = TextfieldFactory.getDefault();
		header.text = "Main";
		container.addChild(header);

		loginButton = new LabelButton("button1", "Login");
		loginButton.addEventListener(EventType.BUTTON_PRESSED, loginSelected);
		container.addChild(loginButton);

		createAccountButton = new LabelButton("button1", "Create account");
		createAccountButton.addEventListener(EventType.BUTTON_PRESSED, createAccountSelected);
		container.addChild(createAccountButton);

		PositionHelper.alignVertically([header, null, loginButton, createAccountButton], new Point(0, 0), 10, PositionHelper.ALIGN_CENTER_W_H, modalBackground);
	};

	public function loginSelected(?e:Event):Void
	{
		StateHandler.getInstance().setStateLogin();
	};

	public function createAccountSelected(e:Event):Void
	{
		StateHandler.getInstance().setStateCreateAccount();
	};

	public override function resize():Void
	{
		super.resize();
		super.centerContainer();
	};

	public override function dispose():Void
	{

	}
}