package state;

import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.geom.Point;

import utils.SoundHandler;
import utils.TextfieldFactory;
import utils.PositionHelper;
import utils.SWFHandler;
import connection.ConnectionHandler;
import message.Message;
import message.MessageHandler;
import message.MessageType;
import user.UserHandler;
import user.User;
import common.StageInfo;
import common.GridSprite;
import common.Button;
import common.LabelButton;
import common.ToggleButton;
import event.EventType;
import common.Image;
import common.Slider;
import state.State;
import state.StateHandler;

class Lobby extends State
{
	private var modalBackground:GridSprite;
	private var header:TextField;
	private var logOutButton:LabelButton;
	private var quickMatchButton:LabelButton;
	private var VSFriendButton:LabelButton;

	public function new():Void
	{
		super();

		modalBackground = new GridSprite("modal", 300, 300, true);
		container.addChild(modalBackground);

		header = TextfieldFactory.getDefault();
		header.text = "Lobby";
		container.addChild(header);

		logOutButton = new LabelButton("button1", "Log out");
		logOutButton.addEventListener(EventType.BUTTON_PRESSED, logOutPressed);
		container.addChild(logOutButton);

		quickMatchButton = new LabelButton("button1", "Quick Match");
		quickMatchButton.addEventListener(EventType.BUTTON_PRESSED, quickMatchSelected);
		container.addChild(quickMatchButton);

		VSFriendButton = new LabelButton("button1", "VS Friend");
		VSFriendButton.addEventListener(EventType.BUTTON_PRESSED, VSFriendSelected);
		container.addChild(VSFriendButton);
	};

	private function logOutPressed(e:Event):Void
	{
		StateHandler.getInstance().setStateStart();
		UserHandler.getInstance().dispose();
	};

	private function quickMatchSelected(e:Event):Void
	{
        var data:Array<Dynamic> = new Array<Dynamic>();
        data.push(UserHandler.getInstance().userId);
        var aMessage = new Message(MessageType.FIND_MATCH, data);
        MessageHandler.getInstance().sendMessage(aMessage);

		StateHandler.getInstance().setStateProgress("Finding game...");
	};

	private function VSFriendSelected(e:Event):Void
	{
		StateHandler.getInstance().setStateFriends();
	};

	public override function resize():Void
	{
		super.resize();

		PositionHelper.alignVertically([header, null, quickMatchButton, VSFriendButton, logOutButton], new Point(0, 0), 10, PositionHelper.ALIGN_CENTER_W_H, modalBackground);

		centerContainer();
	};
}