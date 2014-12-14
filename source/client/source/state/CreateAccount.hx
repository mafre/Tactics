package state;

import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.geom.Point;
import flash.events.KeyboardEvent;

import utils.SoundHandler;
import utils.TextfieldFactory;
import utils.PositionHelper;
import utils.SWFHandler;
import user.UserHandler;
import connection.ConnectionHandler;
import message.Message;
import message.MessageHandler;
import message.MessageType;
import common.StageInfo;
import common.GridSprite;
import common.Button;
import common.LabelButton;
import common.ToggleButton;
import event.EventType;
import common.Image;
import common.Slider;
import state.State;

class CreateAccount extends State
{
	private var header:TextField;
	private var avatarContainer:Sprite;
	private var modalBackground:GridSprite;
	private var inputContainer:Sprite;
	private var backButton:LabelButton;
	private var createButton:LabelButton;
	private var nameInput:TextField;
	private var emailInput:TextField;
	private var passwordInput:TextField;
	private var nameLabel:TextField;
	private var emailLabel:TextField;
	private var passwordLabel:TextField;
	private var avatarLabel:TextField;
	private var avatars:Array<MovieClip>;
	private var shadows:Array<MovieClip>;
	private var selectedAvatar:MovieClip;
	private var selectedAvatarId:Int;
	private var emailTaken:TextField;

	public function new():Void
	{
		super();

		modalBackground = new GridSprite("modal", 500, 400, true);
		container.addChild(modalBackground);

		header = TextfieldFactory.getDefault();
		header.text = "Create account";
		container.addChild(header);

		inputContainer = new Sprite();
		container.addChild(inputContainer);

		avatarContainer = new Sprite();
		inputContainer.addChild(avatarContainer);

		backButton = new LabelButton("button1", "Back");
		backButton.addEventListener(EventType.BUTTON_PRESSED, backSelected);
		container.addChild(backButton);

		createButton = new LabelButton("button1", "Create");
		createButton.addEventListener(EventType.BUTTON_PRESSED, createSelected);
		container.addChild(createButton);

		nameInput = TextfieldFactory.getMenuInput();
		nameInput.type = TextFieldType.INPUT;
		nameInput.maxChars = 32;
		nameInput.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		inputContainer.addChild(nameInput);

		emailInput = TextfieldFactory.getMenuInput();
		emailInput.type = TextFieldType.INPUT;
		emailInput.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		inputContainer.addChild(emailInput);

		passwordInput = TextfieldFactory.getMenuInput();
		passwordInput.type = TextFieldType.INPUT;
		passwordInput.displayAsPassword = true;
		passwordInput.addEventListener(FocusEvent.FOCUS_IN, clearText);
		passwordInput.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		inputContainer.addChild(passwordInput);

		nameLabel = TextfieldFactory.getLeftAligned();
		nameLabel.text = "Name:";
		inputContainer.addChild(nameLabel);

		emailLabel = TextfieldFactory.getLeftAligned();
		emailLabel.text = "Email:";
		inputContainer.addChild(emailLabel);

		passwordLabel = TextfieldFactory.getLeftAligned();
		passwordLabel.text = "Password:";
		inputContainer.addChild(passwordLabel);

		avatarLabel = TextfieldFactory.getLeftAligned();
		avatarLabel.text = "Avatar:";
		inputContainer.addChild(avatarLabel);

		emailTaken = TextfieldFactory.getMenuWarning();
		emailTaken.text = "Email taken";
		//inputContainer.addChild(emailTaken);
		emailTaken.visible = true;

		avatars = new Array<MovieClip>();
		avatars.push(SWFHandler.getMovieclip("Smiley1"));
		avatars.push(SWFHandler.getMovieclip("Smiley2"));
		avatars.push(SWFHandler.getMovieclip("Smiley3"));
		avatars.push(SWFHandler.getMovieclip("Smiley4"));

		shadows = new Array<MovieClip>();
		shadows.push(SWFHandler.getMovieclip("SmileyShadow"));
		shadows.push(SWFHandler.getMovieclip("SmileyShadow"));
		shadows.push(SWFHandler.getMovieclip("SmileyShadow"));
		shadows.push(SWFHandler.getMovieclip("SmileyShadow"));

		for (i in 0...shadows.length)
		{
			avatarContainer.addChild(shadows[i]);
		}

		for (i in 0...avatars.length)
		{
			avatarContainer.addChild(avatars[i]);
			avatars[i].addEventListener(flash.events.MouseEvent.MOUSE_DOWN, avatarSelected);
		};

		MessageHandler.dispatcher.addEventListener(MessageType.CREATE_EMAIL_TAKEN, messageEmailTaken);
	};

	public function clearText(e:FocusEvent):Void
	{
		var tf:TextField = e.target;
		tf.text = "";
	};

	public function avatarSelected(e:flash.events.MouseEvent):Void
	{
		selectAvatar(e.target);
	};

	public function messageEmailTaken(e:Event):Void
	{
		emailTaken.visible = true;
	};

	private function selectAvatar(mc:MovieClip):Void
	{
		if(selectedAvatar != null)
		{
			selectedAvatar.y = 0;
		};

		selectedAvatar = mc;
		selectedAvatar.y = -15;

		for (i in 0...avatars.length)
		{
			if(avatars[i] == selectedAvatar)
			{
				selectedAvatarId = i+1;
			};
		};
	};

	public function createSelected(?e:Event):Void
	{
		emailTaken.visible = false;

		var data:Array<Dynamic> = new Array<Dynamic>();
		data.push(UserHandler.getInstance().userId);
		data.push(nameInput.text);
		data.push(emailInput.text);
		data.push(selectedAvatarId);
		data.push(passwordInput.text);

		var aMessage = new Message(MessageType.CREATE_USER, data);
		MessageHandler.getInstance().sendMessage(aMessage);
	};

	public function keyDown(e:KeyboardEvent):Void
	{
		if(e.keyCode == 13)
		{
			createSelected();
		};
	};

	public function backSelected(e:Event):Void
	{
		StateHandler.getInstance().setStateStart();
	};

	public override function resize():Void
	{
		super.resize();

		createButton.y = modalBackground.height - createButton.height - 30;
		createButton.x = modalBackground.width - createButton.width - 30;

		backButton.y = modalBackground.height - backButton.height - 30;
		backButton.x = 30;

		PositionHelper.alignHorizontally(shadows, new Point(0, 0), null, false, null, 50);
		PositionHelper.alignHorizontally(avatars, new Point(0, 0), null, false, null, 50);
		PositionHelper.alignVertically([nameInput, emailInput, passwordInput, avatarContainer], new Point(0, 0), 10);
		PositionHelper.alignVertically([nameLabel, emailLabel, passwordLabel, avatarLabel], new Point(-10, 0), 10, PositionHelper.ALIGN_LEFT);

		avatarContainer.y += avatarContainer.height;
		avatarContainer.x += avatars[0].width/2;

		emailTaken.x = emailInput.x + emailInput.width + 10;
		emailTaken.y = emailInput.y;

		PositionHelper.alignVertically([header, null, inputContainer], new Point(0, 0), 10, PositionHelper.ALIGN_CENTER_W_H, modalBackground);
		inputContainer.x = modalBackground.width/2 - passwordInput.width/2 + passwordLabel.width/2;
		inputContainer.y -= backButton.height/2;
		header.y -= backButton.height/2;

		super.centerContainer();
	};

	public override function dispose():Void
	{
		emailTaken.visible = false;
		passwordInput.text = "";
	};
}