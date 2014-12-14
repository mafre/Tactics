package user;

class User
{
	public var id:String;
    public var userName:String;
    public var playOrder:Int;

	public function new(aId:String, aName:String, aPlayOrder:Int)
	{
		id = aId;
		userName = aName;
        playOrder = aPlayOrder;
	};
}