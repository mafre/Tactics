package;

import flash.display.Sprite;
import state.StateHandler;
import entity.EntityHandler;

class Main extends Sprite
{
	public function new()
	{
		super();

        StateHandler.getInstance().init(this);
        StateHandler.getInstance().setStateLoad();
	};
}