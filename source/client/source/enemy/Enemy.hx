package enemy;

import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;
import flash.geom.Point;

import common.Image;
import event.EventType;
import event.EventBus;
import utils.SoundHandler;
import enemy.EnemyType;
import entity.EntityType;
import entity.Entity;
import tile.TileBase;

class Enemy extends TileBase
{
    public var id:Int;
    private var enemyType:Int;
	private var asset:Sprite;
    private var hp:Int;

	public function new()
	{
		super();
        type = EntityType.ENEMY;
        layer = 3;
	}

    public function setType(aEnemyType:Int):Void
    {
        enemyType = aEnemyType;

        var typeName:String = "";

        switch(enemyType)
        {
            case 1:

                typeName = EnemyType.TROLL;
                hp = 1;
        };

        var tile:Sprite = new Image("img/tile/default.png");

        asset = new Image("img/enemy/"+typeName+"/default.png");
        asset.x = tile.width/2 - asset.width/2;
        asset.y = tile.height/2 - asset.height;
        addChild(asset);

        addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
    }

	public function mouseDown(e:MouseEvent):Void
	{
		dispatchEvent(new Event(EventType.ENEMY_CLICKED));
	}

    public function damage(aDamage:Int, aCharacterId:Int):Void
    {
        hp -= aDamage;

        if(hp <= 0)
        {
            super.remove();
            EventBus.dispatch(EventTypes.EnemyKilled, [id, aCharacterId]);
        }
    }
}