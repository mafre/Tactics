package message;

class Message
{
	public var type:String;
	public var data:Dynamic;

	public function new(aType:String, ?aData:Dynamic)
	{
		type = aType;

		if(aData != null)
		{
			data = aData;
		};
	};
}