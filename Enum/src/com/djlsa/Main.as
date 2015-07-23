package com.djlsa {
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import com.djlsa.DebugTextField;
	import com.djlsa.Enum;
	import com.djlsa.example.Animal;
	import com.djlsa.example.Colour;
	import com.djlsa.example.Planet;
	import com.miniclip.davidsalsinha.example.Pet;

	/**
	 * @author David Salsinha
	 */
	public class Main extends Sprite 
	{
		
		public function Main()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			var debug:DebugTextField = new DebugTextField(this);

			debug.trace("\nEXAMPLE", "Animal.as\n");

			debug.trace("Enum.values(Animal)", Enum.values(Animal));
			
			debug.trace("\nEXAMPLE", "Colour.as\n");

			debug.trace("Enum.values(Colour)", Enum.values(Colour));
			var red: Colour = Colour.RED;
			debug.trace("var red: Colour = Colour.RED", red);
			var green: Colour = Enum.valueOf(Colour, "GREEN");
			debug.trace("var green: Colour = Enum.valueOf(Colour, \"GREEN\")", green);
			var blue: Colour = Enum.fromValue(Colour, 0, 0, 255);
			debug.trace("var blue: Colour = Enum.fromValue(Colour, 0, 0, 255)", blue);
			var white: Colour = Enum.fromValue(Colour, 255, 255, 255);
			debug.trace("var white: Colour = Enum.fromValue(Colour, 255, 255, 255)", white);
			debug.trace("red.getRGB()", red.getRGB());
			debug.trace("green.getRGB()", green.getRGB());
			debug.trace("blue.getRGB()", blue.getRGB());
			debug.trace("white.getRGB()", white.getRGB());

			debug.trace("\nEXAMPLE", "Planet.as\n");

			debug.trace("Enum.values(Planet)", Enum.values(Planet));
			var earthWeight: Number = 175;
			debug.trace("var earthWeight: Number = 175", earthWeight);
			var mass: Number = earthWeight / Planet.EARTH.surfaceGravity();
			debug.trace("var mass: Number = earthWeight/EARTH.surfaceGravity()", mass);
			debug.trace("for each (var p: Planet in Enum.values(Planet)) p.surfaceWeight(mass)", "");
			var planets: Array = Enum.values(Planet);
			for each (var p: Planet in planets)
				debug.trace("", "Your weight on " + p + " is " + p.surfaceWeight(mass));
		}
		
	}
	
}