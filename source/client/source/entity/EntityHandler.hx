package entity;

import flash.events.EventDispatcher;
import flash.events.Event;
import flash.display.Sprite;

import event.EventType;
import common.StageInfo;
import entity.Entity;
import entity.EntityType;

class EntityHandler
{
	static private var __instance:EntityHandler;

	public var dispatcher:EventDispatcher;
	private var container:Sprite;
	private var items:Array<Entity>;
    private var remove:Array<Entity>;
    private var layers:Array<Sprite>;

    public function new():Void
    {
        dispatcher = new EventDispatcher();
        items = new Array<Entity>();
    };

    public function setContainer(container:Sprite):Void
    {
        this.container = container;
        layers = new Array<Sprite>();

        for (i in 0...9)
        {
            var layer:Sprite = new Sprite();
            layers.push(layer);
            container.addChild(layer);
        };
    };

    public function addEntity(entity:Entity):Void
    {
        items.push(entity);
        layers[entity.layer].addChild(entity);
        entity.init();
    };

    public function getEntities():Array<Entity>
    {
        return items;
    }

    public function removeEntity(entity:Entity):Void
    {
        entity.dispose();

        if(entity.parent != null)
        {
            entity.parent.removeChild(entity);
        };

        items.remove(entity);
    };

    public function update():Void
    {
        remove = new Array<Entity>();

        for (entity in items)
        {
            if(entity.removed)
            {
                remove.push(entity);
            };
        };

        if(remove.length > 0)
        {
            for (entity in remove)
            {
                removeEntity(entity);
            };
        };

        for (entity in items)
        {
            entity.update();
        };
    };

    public function addEventListener(type:String, listener:Dynamic):Void
    {
        dispatcher.addEventListener(type, listener);
    };

    public function removeEventListener(type:String, listener:Dynamic):Void
    {
        dispatcher.removeEventListener(type, listener);
    };

    public static function getInstance():EntityHandler
    {
        if(EntityHandler.__instance == null)
        {
            EntityHandler.__instance = new EntityHandler();
        };

        return EntityHandler.__instance;
    };
}