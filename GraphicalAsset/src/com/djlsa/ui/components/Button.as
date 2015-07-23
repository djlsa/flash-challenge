package com.djlsa.ui.components {
	import flash.text.TextField;
	/**
	 * @author David Salsinha
	 */
	public class Button extends TextField
	{
		public function Button(text: String) 
		{
			width = 100;
			height = 20;
			border = true;
			selectable = false;
			background = true;
			backgroundColor = 0xCCCCCC;
			this.text = text;
		}
	}

}