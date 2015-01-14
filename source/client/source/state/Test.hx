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
        UserHandler.getInstance().setMyUser("1", "Player 1", 0);
        UserHandler.getInstance().addMatchedUser("2", "Player 2", 1);

        CharacterHandler.getInstance().addCharacter(new CharacterModel("1", CharacterType.Rogue));
        CharacterHandler.getInstance().addCharacter(new CharacterModel("1", CharacterType.Knight));
        CharacterHandler.getInstance().addCharacter(new CharacterModel("2", CharacterType.Berserk));
        CharacterHandler.getInstance().addCharacter(new CharacterModel("2", CharacterType.Blacksmith));

        var characters:Array<CharacterModel> = CharacterHandler.getInstance().getAllCharacters();

        for (character in characters)
        {
            switch(character.type)
            {
                case CharacterType.Banshee:

                    addAbility(character.id, AbilityType.FEAR);
                    addAbility(character.id, AbilityType.CURSE);

                case CharacterType.Blacksmith:

                    addAbility(character.id, AbilityType.SHIELD, null, AbilityTargetType.Self);
                    addAbility(character.id, AbilityType.HAMMER, 1);

                case CharacterType.Berserk:

                    addAbility(character.id, AbilityType.SHIELD, null, AbilityTargetType.Self);
                    addAbility(character.id, AbilityType.SWORD, 1);

                case CharacterType.Priest:

                    addAbility(character.id, AbilityType.HEAL);
                    addAbility(character.id, AbilityType.BLESS);

                case CharacterType.Rogue:

                    addAbility(character.id, AbilityType.KNIFE, 1);
                    addAbility(character.id, AbilityType.BOW, 7);

                case CharacterType.Knight:

                    addAbility(character.id, AbilityType.SWORD, 3, AbilityTargetType.Enemy, AbilityTargetArea.VerticalHorizontal);
                    addAbility(character.id, AbilityType.SHIELD, null, AbilityTargetType.Self);
                    addAbility(character.id, AbilityType.TAUNT, 7);

                case CharacterType.Monk:

                    addAbility(character.id, AbilityType.BEER);
                    addAbility(character.id, AbilityType.STAFF);

                case CharacterType.Thief:

                    addAbility(character.id, AbilityType.STEAL);
                    addAbility(character.id, AbilityType.BOW);

                case CharacterType.Druid:

                    addAbility(character.id, AbilityType.FERAL);
                    addAbility(character.id, AbilityType.HEAL);

                case CharacterType.RuneMage:

                    addAbility(character.id, AbilityType.STAFF);
            }
        }

        StateHandler.getInstance().setStatePlay();
    };

    private function addAbility(aCharacterId : Int , aAbilityType : String , ?aRange : Null<Int> , ?aTargetType : AbilityTargetType, ?aTargetArea:AbilityTargetArea):Void
    {
        var ability:Ability = new Ability(aCharacterId, aAbilityType, aRange, aTargetType, aTargetArea);
        AbilityHandler.getInstance().addAbility(ability);
    }
}