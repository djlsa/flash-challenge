package com.djlsa.ui {
	import com.djlsa.ui.components.Button;
	import com.djlsa.ui.components.EditableGraphicalAssetContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	/**
	 * @author David Salsinha
	 */
	public class EditorUI extends Sprite
	{
		private var
			_graphicalAssetContainer: MovieClip = new EditableGraphicalAssetContainer(),
			_addressBar: TextField = new TextField(),
			_loadURLButton: Button = new Button("Load URL"),
			_loadJSONButton: Button = new Button("Load JSON"),
			_outputPanel: TextField = new TextField(),
			_undo: String
		;

		public function EditorUI() 
		{
			addChild(_graphicalAssetContainer);

			_addressBar.width = 760;
			_addressBar.height = 20;
			_addressBar.border = true;
			_addressBar.type = TextFieldType.INPUT;
			_addressBar.text = "https://assets-cdn.github.com/images/modules/logos_page/Octocat.png";
			addChild(_addressBar);

			_loadURLButton.x = 760;
			_loadURLButton.addEventListener(MouseEvent.CLICK, mouseHandler);
			addChild(_loadURLButton);
			
			_loadJSONButton.x = 860;
			_loadJSONButton.addEventListener(MouseEvent.CLICK, mouseHandler);
			addChild(_loadJSONButton);

			_outputPanel.width = 960;
			_outputPanel.height = 20;
			_outputPanel.y = 748;
			addChild(_outputPanel);

			_graphicalAssetContainer.addEventListener(Event.CHANGE, displayOutputHandler);
			_graphicalAssetContainer.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

			_graphicalAssetContainer.loadURL(_addressBar.text);
		}

		/**
		 * Updates output panel (bottom) with the current editor state
		 */
		private function updateOutputPanel(): void
		{
			_outputPanel.text = _graphicalAssetContainer.getJSON();
		}

		private function mouseHandler(event: MouseEvent): void
		{
			// current state to go back to if there's any problem loading
			_undo = _graphicalAssetContainer.getJSON();

			_outputPanel.text = "LOADING";

			if (event.target == _loadURLButton)
				_graphicalAssetContainer.loadURL(_addressBar.text);
			else if (event.target == _loadJSONButton)
				_graphicalAssetContainer.loadJSON(_addressBar.text);
		}

		private function ioErrorHandler(event: IOErrorEvent): void
		{
			// show error in the address bar
			_addressBar.text = event.text;
			// go back to previous state
			_graphicalAssetContainer.loadJSON(_undo);
		}

		private function displayOutputHandler(event: Event): void
		{
			// update JSON on state change
			updateOutputPanel();
		}
	}

}