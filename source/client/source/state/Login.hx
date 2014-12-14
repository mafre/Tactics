package state;

import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.geom.Point;
import flash.net.SharedObject;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;

import utils.SoundHandler;
import utils.TextfieldFactory;
import utils.PositionHelper;
import utils.SWFHandler;
import connection.ConnectionHandler;
import message.Message;
import message.MessageHandler;
import message.MessageType;
import user.UserHandler;
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

class Login extends State
{
	private var header:TextField;
	private var inputContainer:Sprite;
	private var emailInput:TextField;
	private var passwordInput:TextField;
	private var errorText:TextField;
	private var emailLabel:TextField;
	private var passwordLabel:TextField;
	private var loginButton:LabelButton;
	private var backButton:LabelButton;
	private var modalBackground:GridSprite;
	private var so:SharedObject;

	public function new():Void
	{
		super();

		so = SharedObject.getLocal("login");

		modalBackground = new GridSprite("modal", 600, 300, true);
		container.addChild(modalBackground);

		header = TextfieldFactory.getDefault();
		header.text = "Login";
		container.addChild(header);

		inputContainer = new Sprite();
		container.addChild(inputContainer);

		backButton = new LabelButton("button1", "Back");
		backButton.addEventListener(EventType.BUTTON_PRESSED, backSelected);
		container.addChild(backButton);

		loginButton = new LabelButton("button1", "Login");
		loginButton.addEventListener(EventType.BUTTON_PRESSED, loginSelected);
		container.addChild(loginButton);

		emailInput = TextfieldFactory.getMenuInput();
		emailInput.type = TextFieldType.INPUT;
		inputContainer.addChild(emailInput);
		emailInput.addEventListener(FocusEvent.FOCUS_IN, clearText);
		emailInput.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);

		passwordInput = TextfieldFactory.getMenuInput();
		passwordInput.type = TextFieldType.INPUT;
		passwordInput.displayAsPassword = true;
		inputContainer.addChild(passwordInput);
		passwordInput.addEventListener(FocusEvent.FOCUS_IN, clearText);
		passwordInput.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);

		emailLabel = TextfieldFactory.getLeftAligned();
		emailLabel.text = "Email:";
		inputContainer.addChild(emailLabel);

		passwordLabel = TextfieldFactory.getLeftAligned();
		passwordLabel.text = "Password:";
		inputContainer.addChild(passwordLabel);

		errorText = TextfieldFactory.getMenuWarning();
		inputContainer.addChild(errorText);
		errorText.visible = false;

		MessageHandler.dispatcher.addEventListener(MessageType.LOGGED_IN, loginSuccessful);
		MessageHandler.dispatcher.addEventListener(MessageType.LOGIN_WRONG_PASSWORD, messageWrongPassword);
		MessageHandler.dispatcher.addEventListener(MessageType.LOGIN_USER_NOT_FOUND, messageUserNotFound);
	};

	public override function init(?vars:Dynamic):Void
	{
		if(so.data.email != null)
		{
			emailInput.text = so.data.email;
		};
	};

	public function loginSelected(?e:Event):Void
	{
		errorText.visible = false;

		var data:Array<Dynamic> = new Array<Dynamic>();
		data.push(UserHandler.getInstance().userId);
		data.push(emailInput.text);
		data.push(passwordInput.text);

		var aMessage = new Message(MessageType.LOGIN, data);
		MessageHandler.getInstance().sendMessage(aMessage);
	};

	public function loginSuccessful(e:Event):Void
	{
		so.data.email = emailInput.text;
		so.flush();
	};

	public function backSelected(e:Event):Void
	{
		StateHandler.getInstance().setStateStart();
	};

	public function clearText(e:FocusEvent):Void
	{
		var tf:TextField = e.target;
		tf.text = "";
	};

	public function keyDown(e:KeyboardEvent):Void
	{
		if(e.keyCode == 13)
		{
			loginSelected();
		};
	};

	public function messageWrongPassword(e:Event):Void
	{
		errorText.visible = true;
		errorText.text = "Wrong password";
	};

	public function messageUserNotFound(e:Event):Void
	{
		errorText.visible = true;
		errorText.text = "Username not found";
	};

	public override function resize():Void
	{
		super.resize();

		loginButton.x = modalBackground.width - loginButton.width - 30;
		loginButton.y = modalBackground.height - loginButton.height - 30;

		backButton.y = modalBackground.height - loginButton.height - 30;
		backButton.x = 30;

		PositionHelper.alignVertically([emailInput, passwordInput], new Point(0, 0), 10);
		PositionHelper.alignVertically([emailLabel, passwordLabel], new Point(-5, 0), 10, PositionHelper.ALIGN_LEFT);

		errorText.x = emailInput.x + emailInput.width + 10;
		errorText.y = emailInput.y;

		PositionHelper.alignVertically([header, null, inputContainer], new Point(0, 0), 10, PositionHelper.ALIGN_CENTER_W_H, modalBackground);
		inputContainer.x += passwordLabel.width;
		inputContainer.y -= backButton.height/2;
		header.y -= backButton.height/2;

		centerContainer();
	};

	public override function dispose():Void
	{
		errorText.visible = false;
		passwordInput.text = "";

        MessageHandler.dispatcher.removeEventListener(MessageType.LOGGED_IN, loginSuccessful);
        MessageHandler.dispatcher.removeEventListener(MessageType.LOGIN_WRONG_PASSWORD, messageWrongPassword);
        MessageHandler.dispatcher.removeEventListener(MessageType.LOGIN_USER_NOT_FOUND, messageUserNotFound);
	};
}