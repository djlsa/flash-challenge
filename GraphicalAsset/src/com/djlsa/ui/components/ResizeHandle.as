package com.djlsa.ui.components {
	import com.djlsa.ui.components.GraphicalAsset;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	/**
	 * @author David Salsinha
	 */
	public class ResizeHandle extends Sprite
	{
		[Embed(source="resize_handle.png")]
		private var _handleImage: Class;
		private var
			_graphicalAsset: GraphicalAsset,
			_isResizing: Boolean = false
		;

		public function ResizeHandle(graphicalAsset: GraphicalAsset) 
		{
			_graphicalAsset = graphicalAsset;
			this.addChild(new _handleImage());

			addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseHandler);
		}

		/**
		 * Update position according to the graphical asset's position + width/height
		 */
		public function updatePosition(): void
		{
			x = _graphicalAsset.x + _graphicalAsset.width;
			y = _graphicalAsset.y + _graphicalAsset.height;
		}

		private function mouseHandler(event: MouseEvent): void
		{
			switch(event.type)
			{
				case MouseEvent.MOUSE_OVER:
					Mouse.cursor = MouseCursor.BUTTON; break;
				case MouseEvent.MOUSE_OUT:
					Mouse.cursor = MouseCursor.AUTO; break;
				case MouseEvent.MOUSE_DOWN:
					_isResizing = true;
					startDrag();
					break;
				case MouseEvent.MOUSE_UP:
					_isResizing = false;
					stopDrag();
					updatePosition();
					// dispatch a change event
					dispatchEvent(new Event(Event.CHANGE, true));
					break;
				case MouseEvent.MOUSE_MOVE:
					if (_isResizing)
					{
						// change the graphical asset's size
						_graphicalAsset.width = event.stageX - _graphicalAsset.x - event.localX;
						_graphicalAsset.height = event.stageY - _graphicalAsset.y - event.localY;
					}
			}
		}
	}
}