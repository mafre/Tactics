package state;

import flash.display.Sprite;
import flash.display.MovieClip;

import utils.SWFHandler;
import common.StageInfo;
import common.Image;

class State extends Sprite
{
	public var background:Sprite;
	public var container:Sprite;

	public function new():Void
	{
		super();

        background = new Image("img/background/background.png");
		addChild(background);

		container = new Sprite();
		addChild(container);
	};

	public function init(?vars:Dynamic):Void
	{

	};

	public function dispose():Void
	{

	};

	public function resize():Void
	{
		background.width = StageInfo.stageWidth;
		background.height = StageInfo.stageHeight;
	};

	public function update(time:Int):Void
	{

	};

	public function centerContainer():Void
	{
		container.x = StageInfo.stageWidth/2 - container.width/2;
		container.y = StageInfo.stageHeight/2 - container.height/2;
	};

	public function centerContainerSkipWidth():Void
	{
		container.x = StageInfo.stageWidth/2;
		container.y = StageInfo.stageHeight/2 - container.height/2;
	};
}