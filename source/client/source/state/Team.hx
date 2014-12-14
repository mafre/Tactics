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
import message.MessageHandler;
import message.MessageType;
import message.Message;
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

class Team extends State
{
	private var leaveButton:LabelButton;
	private var clearButton:LabelButton;
	private var team1Button:LabelButton;
	private var team2Button:LabelButton;
	private var cpuTeam1Button:LabelButton;
	private var cpuTeam2Button:LabelButton;
	private var startButton:LabelButton;
	private var UserContainer:Sprite;
	private var Users:Array<User>;

	public function new():Void
	{
		super();

		Users = new Array<User>();

		UserContainer = new Sprite();
		container.addChild(UserContainer);

		leaveButton = new LabelButton("button1", "Leave");
		leaveButton.addEventListener(EventType.BUTTON_PRESSED, leavePressed);
		addChild(leaveButton);

		clearButton = new LabelButton("button1", "Clear");
		clearButton.addEventListener(EventType.BUTTON_PRESSED, clearSelected);
		addChild(clearButton);
		clearButton.x = 300;

		team1Button = new LabelButton("button1", "Team 1");
		team1Button.addEventListener(EventType.BUTTON_PRESSED, team1Selected);
		addChild(team1Button);
		team1Button.x = clearButton.x + clearButton.width + 15;

		team2Button = new LabelButton("button1", "Team 2");
		team2Button.addEventListener(EventType.BUTTON_PRESSED, team2Selected);
		addChild(team2Button);
		team2Button.x = team1Button.x + team1Button.width + 15;

		cpuTeam1Button = new LabelButton("button1", "CPU 1");
		cpuTeam1Button.addEventListener(EventType.BUTTON_PRESSED, cpuTeam1Selected);

		if(UserHandler.getInstance().isHost)
		{
			addChild(cpuTeam1Button);
		};

		cpuTeam1Button.x = team2Button.x + team2Button.width + 15;

		cpuTeam2Button = new LabelButton("button1", "CPU 2");
		cpuTeam2Button.addEventListener(EventType.BUTTON_PRESSED, cpuTeam2Selected);

		if(UserHandler.getInstance().isHost)
		{
			addChild(cpuTeam2Button);
		};

		cpuTeam2Button.x = cpuTeam1Button.x + cpuTeam1Button.width + 15;

		startButton = new LabelButton("button1", "Start");
		startButton.addEventListener(EventType.BUTTON_PRESSED, startSelected);
		addChild(startButton);
		startButton.y = StageInfo.stageHeight - startButton.height;
		startButton.x = StageInfo.stageWidth - startButton.width;
		startButton.disable();

		UserHandler.dispatcher.addEventListener(EventType.TEAM_UPDATE, updateTeam);

		StageInfo.addEventListener(EventType.STAGE_RESIZED, resize);
		resize();
	};

	public function updateTeam(e:Event):Void
	{
		for (i in 0...Users.length)
		{
			var User:User = Users[i];
			User.parent.removeChild(User);
		};

		Users = new Array<User>();

		for (i in 0...UserHandler.getInstance().Users.length)
		{
			var User = UserHandler.getInstance().Users[i];
			User.removeEventListener(MouseEvent.CLICK, removeCPU);

			if(User.isCPU())
			{
				User.addEventListener(MouseEvent.CLICK, removeCPU);
			}
			Users.push(User);
		}

		PositionHelper.alignVertically(Users, new Point(0, 0), 10);
		UserContainer.x = StageInfo.stageWidth/2 - UserContainer.width/2;

		var team1Count:Int = 0;
		var team2Count:Int = 0;

		for (i in 0...Users.length)
		{
			var User = Users[i];
			UserContainer.addChild(User);

			if(User.team == 1)
			{
				User.x = -200;
				team1Count++;
			}
			else if(User.team == 2)
			{
				User.x = 200;
				team2Count++;
			}
		}

		team1Button.enable();
		team2Button.enable();
		cpuTeam1Button.enable();
		cpuTeam2Button.enable();

		UserContainer.y = StageInfo.stageHeight/2 - UserContainer.height/2;
	}

	private function leavePressed(e:Event):Void
	{
		StateHandler.getInstance().setStateLogin();
		UserHandler.getInstance().dispose();
	}

	public function removeCPU(e:MouseEvent):Void
	{
		var User:User = e.target;
		MessageHandler.getInstance().removeCPU(User.id);
	}

	public function clearSelected(e:Event):Void
	{
		MessageHandler.getInstance().setMyTeam(0);
	}

	public function team1Selected(e:Event):Void
	{
		MessageHandler.getInstance().setMyTeam(1);
	}

	public function team2Selected(e:Event):Void
	{
		MessageHandler.getInstance().setMyTeam(2);
	}

	public function cpuTeam1Selected(e:Event):Void
	{
		MessageHandler.getInstance().addCPU(1);
	}

	public function cpuTeam2Selected(e:Event):Void
	{
		MessageHandler.getInstance().addCPU(2);
	}

	public function startSelected(e:Event):Void
	{
		MessageHandler.getInstance().myUserReady();
		startButton.disable();
	}

	public override function dispose():Void
	{
		for (i in 0...Users.length)
		{
			var User:User = Users[i];
			User.parent.removeChild(User);
		};

		Users = new Array<User>();

		team1Button.enable();
		team2Button.enable();
	}
}