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

    public function nextRound(aUserId:String):Void
    {
        getUsersCharacters(aUserId);
    }

    public function getUsersCharacters(aUserId:String):Array<CharacterModel>
    {
        var a:Array<Character> = [];

        for(character in characters)
        {
            if(character.userId == aUserId)
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