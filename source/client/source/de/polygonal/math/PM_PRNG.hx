package de.polygonal.math;

class PM_PRNG
{	
	public var seed:Float;

	public function new():Void
	{
		seed = 1;
	};

	/**
	 * provides the next pseudorandom number
	 * as an unsigned integer (31 bits)
	 */
	public function nextInt():Float
	{
		return gen();
	}
	
	/**
	 * provides the next pseudorandom number
	 * as a float between nearly 0 and nearly 1.0.
	 */
	public function nextDouble():Float
	{
		return (gen() / 2147483647);
	}

	/**
	 * generator:
	 * new-value = (old-value * 16807) mod (2^31 - 1)
	 */
	private function gen():Float
	{
		//integer version 1, for max int 2^46 - 1 or larger.
		return seed = (seed * 16807) % 2147483647;
		
		/**
		 * integer version 2, for max int 2^31 - 1 (slowest)
		 */
		//var test:int = 16807 * (seed % 127773 >> 0) - 2836 * (seed / 127773 >> 0);
		//return seed = (test > 0 ? test : test + 2147483647);
		
		/**
		 * david g. carta's optimisation is 15% slower than integer version 1
		 */
		//var hi:uint = 16807 * (seed >> 16);
		//var lo:uint = 16807 * (seed & 0xFFFF) + ((hi & 0x7FFF) << 16) + (hi >> 15);
		//return seed = (lo > 0x7FFFFFFF ? lo - 0x7FFFFFFF : lo);
	}
}