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
import ui.AbilityResultInfo;

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
        EventBus.subscribe(EventTypes.Defeated, defeated);
        EventBus.subscribe(EventTypes.ShowAbilityResultInfo, showAbilityResultInfo);
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
        var damage:Int = aData[2];

        if(id == targetId)
        {
            hp -= damage;

            EventBus.dispatch(EventTypes.ShowAbilityResultInfo, [id, "-"+Std.string(damage)]);

            if(hp <= 0)
            {
                EventBus.dispatch(EventTypes.Defeated, [id, damageDealerId]);
                super.remove();
            }
        }
    }

    private function showAbilityResultInfo(aData:Array<Dynamic>):Void
    {
        var targetId:Int = aData[0];
        var aLabel:String = aData[1];

        if(id == targetId)
        {
            var info:AbilityResultInfo = new AbilityResultInfo(aLabel, asset.width);

            info.x = x + asset.width/2;
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