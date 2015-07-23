package com.djlsa.ui.components {
	import com.djlsa.ui.components.GraphicalAsset;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	/**
	 * @author David Salsinha
	 */
	public class EditableGraphicalAssetContainer extends MovieClip
	{
		private var
			_graphicalAsset: GraphicalAsset = new GraphicalAsset(""),
			_isJSON: Boolean = false,
			_resizeHandle: ResizeHandle = new ResizeHandle(_graphicalAsset),
			_isMoving: Boolean = false
		;

		public function EditableGraphicalAssetContainer()
		{
			addChild(_graphicalAsset);
			addChild(_resizeHandle);

			_graphicalAsset.addEventListener(Event.COMPLETE, loadHandler);
			_graphicalAsset.addEventListener(IOErrorEvent.IO_ERROR, loadHandler);
			_graphicalAsset.addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
			_graphicalAsset.addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
			_graphicalAsset.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			_graphicalAsset.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			_graphicalAsset.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandler);
		}

		/**
		 * Loads a graphical asset from URL
		 * @param url
		 */
		public function loadURL(url: String): void
		{
			_graphicalAsset.loadURL(url);
			_isJSON = false;
			removeChild(_resizeHandle);
		}

		/**
		 * Loads a graphical asset from a JSON formatted string
		 * @param json
		 */
		public function loadJSON(json: String): void
		{
			_graphicalAsset.loadJSON(json);
			_isJSON = true;
			if(_resizeHandle.stage)
				removeChild(_resizeHandle);
		}

		/**
		 * @return JSON string of the current state
		 */
		public function getJSON(): String
		{
			// strip slashes
			return JSON.stringify(_graphicalAsset).replace(/\\/g, "");
		}

		private function loadHandler(event: Event): void
		{
			if (event.type == Event.COMPLETE)
			{
				// check if it's not from JSON, in that case it has no position
				if (!_isJSON)
				{
					// center the asset
					_graphicalAsset.x = stage.stageWidth / 2 - _graphicalAsset.width / 2;
					_graphicalAsset.y = stage.stageHeight / 2 - _graphicalAsset.height / 2;
				}

				addChild(_resizeHandle);
				_resizeHandle.updatePosition();

				dispatchEvent(new Event(Event.CHANGE));
			}

			// dispatch all other events
			dispatchEvent(event);
		}

		private function mouseHandler(event: MouseEvent): void
		{
			switch(event.type)
			{
				case MouseEvent.MOUSE_OVER:
					Mouse.cursor = MouseCursor.HAND; break;
				case MouseEvent.MOUSE_OUT:
					Mouse.cursor = MouseCursor.AUTO; break;
				case MouseEvent.MOUSE_DOWN:
					_isMoving = true;
					_graphicalAsset.startDrag();
					break;
				case MouseEvent.MOUSE_UP:
					_isMoving = false;
					_graphicalAsset.stopDrag();
					// dispatch a change event
					dispatchEvent(new Event(Event.CHANGE));
					break;
				case MouseEvent.MOUSE_MOVE:
					if (_isMoving)
						// make resize handle follow the graphical asset
						_resizeHandle.updatePosition();
					break;
			}
		}
	}

}