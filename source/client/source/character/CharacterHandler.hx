package character;

import flash.display.Sprite;
import flash.geom.Point;
import flash.display.MovieClip;
import flash.utils.Object;

import common.StageInfo;
import character.CharacterModel;
import event.EventBus;

class CharacterHandler
{
	static private var __instance:CharacterHandler;

    private var characters:Array<CharacterModel>;

	public function new()
	{
        characters = [];
        EventBus.subscribe(EventTypes.CharacterKilled, characterKilled);
	};

    public function addCharacter(aCharacter:CharacterModel):Void
    {
        aCharacter.id = characters.length+1;
        characters.push(aCharacter);
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

    private function characterKilled(aData:Array<Dynamic>):Void
    {
        var characterId:Int = aData[0];
        var character:CharacterModel = getCharacter(characterId);
        characters.remove(character);
    }

    public function roundComplete(aUserId:String):Void
    {
        var a:Array<CharacterModel> = getUsersCharacters(aUserId);

        for(character in a)
        {
            character.setEnabled(false);
        }
    }

    public function startRound(aUserId:String):Void
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

    public function getOpponentCharacters(aUserId:String):Array<CharacterModel>
    {
        var a:Array<CharacterModel> = [];

        for(character in characters)
        {
            if(character.userId != aUserId)
            {
                a.push(character);
            }
        }

        return a;
    }

    public function getAllCharacters():Array<CharacterModel>
    {
        return characters;
    }

	public static function getInstance():CharacterHandler
    {
        if (CharacterHandler.__instance == null)
            CharacterHandler.__instance = new CharacterHandler();
        return CharacterHandler.__instance;
    };
}