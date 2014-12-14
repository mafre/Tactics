package state;

import character.CharacterHandler;
import character.CharacterModel;
import ability.AbilityHandler;
import ability.AbilityType;
import ability.Ability;
import state.State;
import state.StateHandler;
import user.UserHandler;

class Test extends State
{
	public function new():Void
	{
		super();
	};

    public override function init(?vars:Dynamic):Void
    {
        UserHandler.getInstance().setMyUser("1", "username1", 0);
        UserHandler.getInstance().addMatchedUser("2", "username2", 1);

        CharacterHandler.getInstance().addCharacter(new CharacterModel("1", CharacterType.Rogue));
        CharacterHandler.getInstance().addCharacter(new CharacterModel("1", CharacterType.Knight));
        CharacterHandler.getInstance().addCharacter(new CharacterModel("2", CharacterType.Berserk));

        var characters:Array<CharacterModel> = CharacterHandler.getInstance().getAllCharacters();

        for (character in characters)
        {
            switch(character.type)
            {
                case CharacterType.Banshee:

                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.FEAR));
                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.CURSE));

                case CharacterType.Blacksmith:

                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.SHIELD));
                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.HAMMER));

                case CharacterType.Berserk:

                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.SHIELD, null, AbilityTargetType.Self));
                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.SWORD, 1));

                case CharacterType.Priest:

                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.HEAL));
                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.BLESS));

                case CharacterType.Rogue:

                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.KNIFE, 1));
                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.BOW, 10));

                case CharacterType.Knight:

                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.TAUNT, 10));
                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.SHIELD, null, AbilityTargetType.Self));

                case CharacterType.Monk:

                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.BEER));
                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.STAFF));

                case CharacterType.Thief:

                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.STEAL));
                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.BOW));

                case CharacterType.Druid:

                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.FERAL));
                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.HEAL));

                case CharacterType.RuneMage:

                    AbilityHandler.getInstance().addAbility(new Ability(character.id, AbilityType.STAFF));
            }
        }

        StateHandler.getInstance().setStatePlay();
    };
}