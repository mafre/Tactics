package utils;

import de.polygonal.math.PM_PRNG;

class Random
{
	public static var random:PM_PRNG = new PM_PRNG();

	public static function setSeed(seed:Float):Void
	{
		random.seed = seed;
	}

	public static function getValue():Float
	{
		return random.nextDouble();
	}
}