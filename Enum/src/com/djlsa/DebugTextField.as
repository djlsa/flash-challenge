package com.djlsa 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author David Salsinha
	 */
	public class DebugTextField extends TextField 
	{
		public function DebugTextField(parentObject: Sprite)
		{
			super();
			this.width = parentObject.stage.stageWidth;
			this.height = parentObject.stage.stageHeight;
			this.multiline = true;
			this.wordWrap = true;
			parentObject.addChild(this);

			parentObject.stage.addEventListener(Event.RESIZE, onStageResize); 
		}

		public function trace(code: String, result: String): void
		{
			this.htmlText = this.htmlText.concat("<b>" + code + " &gt;&gt;</b> " + result + "<br>");
		}
		
		private function onStageResize(event: Event): void
		{
			this.width = parent.stage.stageWidth;
			this.height = parent.stage.stageHeight;
		}
	}

}