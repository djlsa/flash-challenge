package com.djlsa.example
{
	import com.djlsa.Enum;

	/**
	 * @author David Salsinha
	 */
	public class Colour extends Enum
	{
		{
			Enum.init(Colour, "R", "G", "B");
		}

		public static var
			RED: Colour = Enum.initValue(Colour, 255, 0, 0),
			GREEN: Colour = Enum.initValue(Colour, 0, 255, 0),
			BLUE: Colour = Enum.initValue(Colour, 0, 0, 255);
		;

		public function getRGB(): String
		{
			return "" + values.R + "," + values.G + "," + values.B;
		}
	}
}