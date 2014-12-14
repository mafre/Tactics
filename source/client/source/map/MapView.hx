package map;

import flash.events.EventDispatcher;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Function;
import flash.display.Sprite;
import flash.geom.Point;

import entity.EntityHandler;
import entity.EntityType;
import event.EventBus;
import common.StageInfo;
import map.MapModel;
import enemy.Enemy;
import openfl.tiled.TiledMap;
import openfl.Assets;
import character.CharacterModel;
import character.CharacterView;
import character.CharacterHandler;
import tile.TileHelper;
import tile.SelectionTile;
import tile.TargetTile;
import ability.AbilityHandler;
import user.UserHandler;

class MapView extends Sprite
{
    private var mapIndex:Int;
    private var tiledMap:TiledMap;
    private var mapModel:MapModel;
    private var currentMap:Map;

    public function new(aMapModel:MapModel):Void
    {
        super();

        mapIndex = 0;
        mapModel = aMapModel;
        mapModel.load();

        EventBus.subscribe(EventTypes.SelectCharacter, selectCharacter);
        EventBus.subscribe(EventTypes.SetCharacterPosition, setCharacterPosition);
        EventBus.subscribe(EventTypes.UseAbilityGetTargetTiles, useAbilityGetTargetTiles);
        EventBus.subscribe(EventTypes.UseAbilityTargetTileSelected, useAbilityTargetTileSelected);
        EventBus.subscribe(EventTypes.Defeated, defeated);
    };

    public function loadMap(aId:Int):Void
    {
        /*
            - layers -
            1: target tiles
            2: selection tile
            3: enemies & characters
        */

        var selection:SelectionTile = new SelectionTile();
        EntityHandler.getInstance().addEntity(selection);

        var map:Map = mapModel.getMap(aId);
        currentMap = map;
        tiledMap = TiledMap.fromAssets("assets/tiles/"+map.get_mapName()+".tmx");
        addChild(tiledMap);
        tiledMap.addEventListener(MouseEvent.CLICK, tiledMapClicked);

        var tileCount = 0;
        for (x in 0...map.get_width())
        {
            for (y in 0...map.get_height())
            {
                var tile:TargetTile = new TargetTile(tileCount);
                tileCount++;
                tile.setPosition(new Point(x, y));
                EntityHandler.getInstance().addEntity(tile);
                tile.hide();
                map.set_target(x, y, tileCount);
            }
        }

        var enemyCount:Int = 0;

        for (x in 0...map.get_width())
        {
            for (y in 0...map.get_height())
            {
                var aType:Int = map.get_enemy(x, y);

                if(aType > 0)
                {
                    var enemy:Enemy = new Enemy();
                    enemy.id = enemyCount+1000;
                    enemy.setType(aType);
                    enemy.setPosition(new Point(x, y));
                    EntityHandler.getInstance().addEntity(enemy);
                    map.set_enemy(cast(enemy.getPosition().x, Int), cast(enemy.getPosition().y, Int), enemy.id);
                    enemyCount++;
                }
            };
        };

        for(user in UserHandler.getInstance().getUserOrder())
        {
            var characterModels:Array<CharacterModel> = CharacterHandler.getInstance().getUsersCharacters(user.id);

            for (i in 0...characterModels.length)
            {
                var characterModel:CharacterModel = characterModels[i];
                var characterView:CharacterView = new CharacterView(characterModel.id, characterModel.getAssetPath());
                var startPosition:Point = new Point(map.get_start_x_position(user.playOrder), map.get_start_y_position(user.playOrder)+i);
                map.set_character(cast(startPosition.x, Int), cast(startPosition.y, Int), characterModel.id);
                characterModel.initPosition(startPosition);
                characterView.setPosition(startPosition);
                EntityHandler.getInstance().addEntity(characterView);
            }
        }

        EventBus.dispatch(EventTypes.NextTurn);
    }

    private function tiledMapClicked(e:MouseEvent):Void
    {
        EventBus.dispatch(EventTypes.DeselectCharacter);
    }

    private function selectCharacter(aData:Array<Dynamic>):Void
    {
        var characterId:Int = aData[0];
        var characterPos:Point = aData[1];
        var moves:Int = aData[2];
        var distance:Int = 0;
        var tileCount:Int = 0;

        for (x in 0...currentMap.get_width())
        {
            for (y in 0...currentMap.get_height())
            {
                distance = TileHelper.getDistanceBetweenPoint(characterPos, new Point(x, y));

                if(!currentMap.is_occupied(x, y) && distance <= moves)
                {
                    EventBus.dispatch(EventTypes.ShowMoveTile, tileCount);
                }

                tileCount++;
            };
        };

        trace("select");
        EventBus.dispatch(EventTypes.UpdateAbilities, [characterId, characterPos, getValidTargets(characterId)]);
    }

    private function useAbilityGetTargetTiles(aData:Array<Dynamic>):Void
    {
        var enemyPositions:Array<Point> = currentMap.getAllEnemyPositions();
        var characterPositions:Array<Point> = currentMap.getAllCharacterPositions();
        var ownerPosition:Point = aData[0];
        var userId:String = aData[1];
        var range:Int = aData[2];

        var validTargets:Array<Int> = [];

        for (enemyPosition in enemyPositions)
        {
            var distance:Int = TileHelper.getDistanceBetweenPoint(ownerPosition, enemyPosition);

            if(range >= distance)
            {
                validTargets.push(currentMap.get_enemy(cast(enemyPosition.x, Int), cast(enemyPosition.y, Int)));
            }
        }

        for (characterPosition in characterPositions)
        {
            var distance:Int = TileHelper.getDistanceBetweenPoint(ownerPosition, characterPosition);

            if(range >= distance)
            {
                validTargets.push(currentMap.get_character(cast(characterPosition.x, Int), cast(characterPosition.y, Int)));
            }
        }

        var tileCount:Int = 0;

        for (x in 0...currentMap.get_width())
        {
            for (y in 0...currentMap.get_height())
            {
                for (validTarget in validTargets)
                {
                    if(currentMap.get_enemy(x, y) == validTarget || currentMap.get_character(x, y) == validTarget)
                    {
                        EventBus.dispatch(EventTypes.UseAbilityShowTargetTile, tileCount);
                    }
                }

                tileCount++;
            };
        };
    }

    private function useAbilityTargetTileSelected(aData:Array<Dynamic>):Void
    {
        var abilityId:Int = aData[0];
        var targetPosition:Point = aData[1];

        var value:Int = currentMap.get_value(cast(targetPosition.x, Int), cast(targetPosition.y, Int));

        if(value != 0)
        {
            EventBus.dispatch(EventTypes.UseAbilityApply, [abilityId, value]);
            return;
        }
        else
        {
            trace("apply ability - id not found");
        }
    }

    private function setCharacterPosition(aData:Array<Dynamic>):Void
    {
        var characterId:Int = aData[0];
        var newPos:Point = aData[1];
        currentMap.move_character(characterId, cast(newPos.x, Int), cast(newPos.y, Int));
        EventBus.dispatch(EventTypes.UpdateAbilities, [characterId, newPos, getValidTargets(characterId)]);
    }

    private function getValidTargets(aUnitId:Int):Array<Point>
    {
        var validTargets:Array<Point> = currentMap.getAllUnitPositionsExcept(aUnitId);
        return validTargets;
    }

    private function defeated(aData:Array<Dynamic>):Void
    {
        var defeatedId:Int = aData[0];
        var defeaterId:Int = aData[1];
        var characterPos:Point = currentMap.find_character(defeatedId);
        var enemyPos:Point = currentMap.find_enemy(defeatedId);
        var defeaterPos:Point = currentMap.find_character(defeaterId);

        if(defeaterPos == null)
        {
            defeaterPos = currentMap.find_enemy(defeaterId);
        }

        if(characterPos != null)
        {
            currentMap.remove_character(defeatedId);
        }

        if(enemyPos != null)
        {
            currentMap.remove_enemy(defeatedId);
        }

        EventBus.dispatch(EventTypes.UpdateAbilities, [defeaterId, defeaterPos, getValidTargets(defeaterId)]);
    }
}