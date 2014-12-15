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

		addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);

        EventBus.subscribe(EventTypes.UseAbilityApply, abilityApply);
        EventBus.subscribe(EventTypes.UpdateAbility, updateAbility);
        EventBus.subscribe(EventTypes.UseAbility, useAbility);
        EventBus.subscribe(EventTypes.DisableAbilities, disable);

        setEnabled(false);
	}

     private function updateAbility(aData:Array<Dynamic>):Void
    {
        var aId:Int = aData[0];
        var enabled:Bool = aData[1];

        if(id == aId)
        {
            setEnabled(enabled);
        }
    }

    private function abilityApply(aData:Array<Dynamic>):Void
    {
        selected = false;
        close.visible = false;
        ok.visible = false;
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
            switch(targetType)
            {
                case AbilityTargetType.Self:

                    EventBus.dispatch(EventTypes.UseAbilityApply, [id, 0]);
                    close.visible = false;
                    ok.visible = false;

                case AbilityTargetType.AllEnemies:

                    EventBus.dispatch(EventTypes.UseAbilityApply, [id, 0]);
                    close.visible = false;
                    ok.visible = false;

                case AbilityTargetType.AllAllies:

                    EventBus.dispatch(EventTypes.UseAbilityApply, [id, 0]);
                    close.visible = false;
                    ok.visible = false;

                default:

                    EventBus.dispatch(EventTypes.CancelAbility);
                    close.visible = false;
                    ok.visible = false;
            }
        }
    }

    private function disable():Void
    {
        setEnabled(false);
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