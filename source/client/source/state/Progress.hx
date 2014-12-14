package state;

import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.geom.Point;

import common.GridSprite;
import common.LabelButton;
import event.EventType;
import utils.TextfieldFactory;
import utils.PositionHelper;
import utils.SWFHandler;
import state.State;
import common.Animation;
import common.StageInfo;

class Progress extends State
{
	private var modalBackground:GridSprite;
	private var label:TextField;
    private var spinner:Animation;
	private var cancelButton:LabelButton;

	public function new():Void
	{
		super();

		modalBackground = new GridSprite("modal", 300, 400, true);
		container.addChild(modalBackground);

		label = TextfieldFactory.getDefault();
		label.text = "";
		container.addChild(label);

        spinner = new Animation(true);
        spinner.setPath("img/spinner");
        spinner.setFrames([1, 2, 3, 4]);
        spinner.setDelay(3);
        spinner.scaleX = spinner.scaleY = StageInfo.scale;
		container.addChild(spinner);

		cancelButton = new LabelButton("button1", "Cancel");
		cancelButton.addEventListener(EventType.BUTTON_PRESSED, cancelSelected);
		container.addChild(cancelButton);
	};

	public override function init(?vars:Dynamic):Void
	{
		label.text = vars;
        spinner.show();
		PositionHelper.alignVertically([label, spinner, cancelButton], new Point(0, 0), 30, PositionHelper.ALIGN_CENTER_W_H, modalBackground);
	};

	public function cancelSelected(e:Event):Void
	{
		StateHandler.getInstance().setStateLobby();
	};

	public override function resize():Void
	{
		super.resize();
		centerContainer();
	};

    public override function update(time:Int):Void
    {
        spinner.update();
    };
}