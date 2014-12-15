package character;

import flash.display.Sprite;
import flash.geom.Point;
import flash.display.MovieClip;
import flash.utils.Object;

import common.StageInfo;
import character.CharacterModel;
import enemy.Enemy;
import event.EventBus;

class CharacterHandler
{
	static private var __instance:CharacterHandler;

    private var characters:Array<CharacterModel>;
    private var enemies:Array<Enemy>;

	public function new()
	{
        characters = [];
        enemies = [];

        EventBus.subscribe(EventTypes.Defeated, defeated);
        EventBus.subscribe(EventTypes.GetOpponentPositionsQuery, getOpponentPositionsQuery);
        EventBus.subscribe(EventTypes.GetAllyPositionsQuery, getAllyPositionsQuery);
	};

    public function addCharacter(aCharacter:CharacterModel):Void
    {
        aCharacter.id = characters.length+1;
        characters.push(aCharacter);
    }

    public function addEnemy(aEnemy:Enemy):Void
    {
        aEnemy.id = enemies.length+1000;
        enemies.push(aEnemy);
    }

    public function getCharacter(aId:Int):CharacterModel
    {
        for(character in characters)
        {
            if(character.id == aId)
            {
                return character;
            }
        }

        return null;
    }

    public function defeated(aData:Array<Dynamic>):Void
    {
        var aUserId:String = aData[1];

        var a:Array<Dynamic> = getOpponents(aUserId);

        if(a.length == 0)
        {
            EventBus.dispatch(EventTypes.UserWon, aUserId);
        }
    }

    public function resetUsersCharacters(aUserId:String):Void
    {
        var a:Array<CharacterModel> = getUsersCharacters(aUserId);

        for(character in a)
        {
            character.reset();
        }
    }

    public function disableUser(aUserId:String):Void
    {
        var a:Array<CharacterModel> = getUsersCharacters(aUserId);

        for(character in a)
        {
            character.setEnabled(false);
        }
    }

    public function enableUser(aUserId:String):Void
    {
        var a:Array<CharacterModel> = getUsersCharacters(aUserId);

        for(character in a)
        {
            character.setEnabled(true);
        }
    }

    public function getUsersCharacters(aUserId:String):Array<CharacterModel>
    {
        var a:Array<CharacterModel> = [];

        for(character in characters)
        {
            if(character.userId == aUserId)
            {
                a.push(character);
            }
        }

        return a;
    }

    private function getOpponents(aUserId:String):Array<Dynamic>
    {
        var a:Array<Dynamic> = [];

        for(character in characters)
        {
            if(character.userId != aUserId)
            {
                a.push(character);
            }
        }

        for (enemy in enemies)
        {
            a.push(enemy);
        }

        return a;
    }

    public function getOpponentIDs(aUserId:String):Array<Int>
    {
        var a:Array<Int> = [];

        for(character in characters)
        {
            if(character.userId != aUserId)
            {
                a.push(character.id);
            }
        }

        for (enemy in enemies)
        {
            a.push(enemy.id);
        }

        return a;
    }

    public function getOpponentPositionsQuery(aData:Array<Dynamic>):Void
    {
        var userId:String = aData[0];
        var data:Array<Dynamic> = aData[1];
        var a:Array<Point> = [];

        for(character in characters)
        {
            if(character.userId != userId)
            {
                a.push(character.getPosition());
            }
        }

        for (enemy in enemies)
        {
            a.push(enemy.getPosition());
        }

        EventBus.dispatch(EventTypes.GetPositionsResult, [a, data]);
    }

    public function getAllyPositionsQuery(aUserId:String):Void
    {
        var a:Array<Point> = [];

        for(character in characters)
        {
            if(character.userId != aUserId)
            {
                a.push(character.getPosition());
            }
        }

        EventBus.dispatch(EventTypes.GetPositionsResult, a);
    }

    public function getAllCharacters():Array<CharacterModel>
    {
        return characters;
    }

    public function getAllEnemies():Array<Enemy>
    {
        return enemies;
    }

	public static function getInstance():CharacterHandler
    {
        if (CharacterHandler.__instance == null)
            CharacterHandler.__instance = new CharacterHandler();
        return CharacterHandler.__instance;
    };
}