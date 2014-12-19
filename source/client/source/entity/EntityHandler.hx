package entity;

import flash.events.EventDispatcher;
import flash.events.Event;
import flash.display.Sprite;

import event.EventType;
import common.StageInfo;
import entity.Entity;
import entity.EntityType;

import haxe.ds.IntMap;

class EntityHandler
{
	static private var __instance:EntityHandler;

	public var dispatcher:EventDispatcher;
	private var container:Sprite;
	private var items:Array<Entity>;
    private var remove:Array<Entity>;
    private var layers:Array<Sprite>;
    private var layerItems:IntMap<Array<Entity>>;

    public function new():Void
    {
        dispatcher = new EventDispatcher();
        items = new Array<Entity>();
        layerItems = new IntMap<Array<Entity>>();
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
            layerItems.set(i, new Array<Entity>());
        };
    };

    public function addEntity(entity:Entity):Void
    {
        items.push(entity);
        layers[entity.layer].addChild(entity);
        layerItems.get(entity.layer).push(entity);
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

        layerItems.get(entity.layer).remove(entity);
        items.remove(entity);
    };

    private function sortByY(a:Sprite, b:Sprite):Int
    {
        if (a.y == b.y) return 0;
        if (a.y > b.y) return 1;
        return -1;
    }

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

        var i:Int;

        for (i in 0...9)
        {
            var a:Array<Entity> = layerItems.get(i);
            a.sort(sortByY);

            for (i in 0...a.length)
            {
                if(a[i].parent != null)
                {
                    a[i].parent.setChildIndex(a[i], i);
                }
            }
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