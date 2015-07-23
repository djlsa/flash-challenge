package com.djlsa.example 
{
	import com.djlsa.Enum;

	/**
	 * @author David Salsinha
	 * 
	 * Example adapted from:
	 * @see http://docs.oracle.com/javase/tutorial/java/javaOO/enum.html
	 */
	public class Planet extends Enum
	{
		{
			Enum.init(Planet,
				"mass", // in kilograms
				"radius", // in metres
				"ordinal"
			);
		}
		public static var
			MERCURY: Planet = Enum.initValue(Planet, 3.303e+23, 2.4397e6, 1),
			VENUS: Planet = Enum.initValue(Planet, 4.869e+24, 6.0518e6, 2),
			EARTH: Planet = Enum.initValue(Planet, 5.976e+24, 6.37814e6, 3),
			MARS: Planet = Enum.initValue(Planet, 6.421e+23, 3.3972e6, 4),
			JUPITER: Planet = Enum.initValue(Planet, 1.9e+27, 7.1492e7, 5),
			SATURN: Planet = Enum.initValue(Planet, 5.688e+26, 6.0268e7, 6),
			URANUS: Planet = Enum.initValue(Planet, 8.686e+25, 2.5559e7, 7),
			NEPTUNE: Planet = Enum.initValue(Planet, 1.024e+26, 2.4746e7, 8)
		;

		// universal gravitational constant (m3 kg-1 s-2)
		private static const G: Number = 6.67300E-11;

		public function surfaceGravity(): Number
		{
			return G * values.mass / (values.radius * values.radius);
		}

		public function surfaceWeight(otherMass: Number): Number
		{
			return otherMass * surfaceGravity();
		}
	}
}