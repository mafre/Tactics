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
import entity.EntityHandler;
import entity.EntityType;
import entity.Entity;
import tile.TileBase;
import ui.AttackResultInfo;

class Enemy extends TileBase
{
    public var id:Int;
    private var hp:Int;
    private var str:Int;

    private var enemyType:Int;
    private var asset:Sprite;

	public function new()
	{
		super();
        type = EntityType.ENEMY;
        layer = 3;

        EventBus.subscribe(EventTypes.TakeDamage, takeDamage);
        EventBus.subscribe(EventTypes.DealDamage, dealDamage);
        EventBus.subscribe(EventTypes.ShowBlocked, showBlocked);
        EventBus.subscribe(EventTypes.Defeated, defeated);
	}

    public function setType(aEnemyType:Int):Void
    {
        enemyType = aEnemyType;
        hp = 1;
        str = 1;

        var typeName:String = "";

        switch(enemyType)
        {
            case 1:

                typeName = EnemyType.TROLL;
                hp = 100;
                str = 20;
        };

        var tile:Sprite = new Image("img/tile/default.png");

        asset = new Image("img/enemy/"+typeName+"/default.png");
        asset.x = tile.width/2 - asset.width/2;
        asset.y = tile.height/2 - asset.height;
        addChild(asset);

        addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
    }

    private function dealDamage(aData:Array<Dynamic>):Void
    {
        var damageDealerId:Int = aData[0];
        var targetId:Int = aData[1];

        if(id == damageDealerId)
        {
            EventBus.dispatch(EventTypes.TakeDamage, [id, targetId, getAtk()]);
        }
    }

    public function takeDamage(aData:Array<Dynamic>):Void
    {
        var damageDealerId:Int = aData[9];
        var targetId:Int = aData[1];
        var value:Int = aData[2];

        if(id == targetId)
        {
            hp -= value;

            if(hp <= 0)
            {
                EventBus.dispatch(EventTypes.Defeated, [id, damageDealerId]);
                super.remove();
            }
            else
            {
                var info:AttackResultInfo = new AttackResultInfo(Std.string(value));

                info.x = x + asset.width/2 - info.width/2;
                info.y = y - asset.height - 3;

                EntityHandler.getInstance().addEntity(info);
            }
        }
    }

    private function showBlocked(targetId:Int):Void
    {
        if(id == targetId)
        {
            var info:AttackResultInfo = new AttackResultInfo("Blocked");

            info.x = x + asset.width/2 - info.width/2;
            info.y = y - asset.height - 3;

            EntityHandler.getInstance().addEntity(info);
        }
    }

    private function getAtk():Int
    {
        return str;
    }

    private function defeated(aData:Array<Dynamic>):Void
    {
        var targetId:Int = aData[0];

        if(id == targetId)
        {
            super.remove();
        }
    }

	public function mouseDown(e:MouseEvent):Void
	{
		dispatchEvent(new Event(EventType.ENEMY_CLICKED));
	}
}