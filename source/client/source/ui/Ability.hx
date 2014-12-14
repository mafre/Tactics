package ui;

import flash.events.MouseEvent;
import flash.events.Event;
import flash.display.Sprite;

import common.Image;
import common.StageInfo;
import event.EventType;
import utils.SoundHandler;
import ability.AbilityHandler;
import event.EventBus;
import ability.Ability;

class Ability extends Sprite
{
    public var id:Int;
    private var asset:Sprite;
    private var selected:Bool;
    private var close:Sprite;
    private var ok:Sprite;
    private var enabled:Bool;
    private var abilityType:String;
    private var targetType:AbilityTargetType;

	public function new(aId:Int, aAbilityType:String, aTargetType:AbilityTargetType)
	{
		super();

        id = aId;
        selected = false;
        abilityType = aAbilityType;
        targetType = aTargetType;

		asset = new Image("img/ability/"+aAbilityType+".png");
        asset.scaleX = asset.scaleY = 4;
		addChild(asset);

        close = new Image("img/close/close_down.png");
        addChild(close);
        close.scaleX = close.scaleY = StageInfo.scale;
        close.x = asset.width/2 - close.width/2;
        close.y = asset.height/2 - close.height/2;
        close.visible = false;

        ok = new Image("img/ok/ok.png");
        addChild(ok);
        ok.scaleX = ok.scaleY = StageInfo.scale;
        ok.x = asset.width/2 - ok.width/2;
        ok.y = asset.height/2 - ok.height/2;
        ok.visible = false;

        enabled = false;

		addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);

        EventBus.subscribe(EventTypes.UseAbilityApply, abilityApply);
        EventBus.subscribe(EventTypes.UpdateAbilityIcon, updateEnabled);
        EventBus.subscribe(EventTypes.UseAbility, useAbility);
	}

     private function updateEnabled(aData:Array<Dynamic>):Void
    {
        if(id == aData[0])
        {
            setEnabled(aData[1]);
        }
    }

    private function abilityApply(aData:Array<Dynamic>):Void
    {
        setSelected(false);
    }

	public function mouseDown(e:MouseEvent):Void
	{
        if(!enabled)
        {
            return;
        }

        setSelected(!selected);
	}

    private function useAbility(aId:Int):Void
    {
        if(id != aId)
        {
            close.visible = false;
            ok.visible = false;
            selected = false;
        }
    }

    private function setSelected(aSelected:Bool):Void
    {
        selected = aSelected;

        if(selected)
        {
            EventBus.dispatch(EventTypes.HideTargetTiles);
            EventBus.dispatch(EventTypes.UseAbility, id);

            switch(targetType)
            {
                case AbilityTargetType.Self:

                    close.visible = false;
                    ok.visible = true;

                case AbilityTargetType.AllEnemies:

                    close.visible = false;
                    ok.visible = true;

                case AbilityTargetType.AllAllies:

                    close.visible = false;
                    ok.visible = true;

                default:

                    close.visible = true;
                    ok.visible = false;
            }
        }
        else
        {
            EventBus.dispatch(EventTypes.CancelAbility);
            close.visible = false;
            ok.visible = false;
        }
    }

    public function setEnabled(aEnabled:Bool):Void
    {
        enabled = aEnabled;

        if(aEnabled)
        {
            asset.alpha = 1;
        }
        else
        {
            asset.alpha = 0.5;
        }
    }
}