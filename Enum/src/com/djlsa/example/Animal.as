package com.djlsa.example 
{
	import com.djlsa.Enum;

	/**
	 * @author David Salsinha
	 */
	public class Animal extends Enum
	{
		{
			Enum.init(Animal);
		}
		public static var
			CAT: Animal,
			DOG: Animal,
			FISH: Animal
	}

}