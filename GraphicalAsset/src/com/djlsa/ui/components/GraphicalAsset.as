package com.djlsa.ui.components {
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	/**
	 * @author David Salsinha
	 */
	public class GraphicalAsset extends MovieClip
	{
		private var
			_loader: Loader = new Loader(),
			_url: URLRequest = new URLRequest()
		;

		public function GraphicalAsset(url: String)
		{
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, eventHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, eventHandler);
			addChild(_loader);
			loadURL(url);
		}

		private function eventHandler(event: Event): void
		{
			if (event.type == Event.COMPLETE)
			{
				this.width = _loader.content.width;
				this.height = _loader.content.height;
			}

			// dispatches all other events
			this.dispatchEvent(event);
		}

		/**
		 * Loads a graphical asset from URL
		 * @param url URL of the image or SWF to load
		 */
		public function loadURL(url: String): void
		{
			_url.url = url;
			_loader.load(_url);
		}

		/**
		 * Loads a graphical asset and state from JSON
		 * @param json JSON formatted string with data
		 */
		public function loadJSON(json: String): void
		{
			try
			{
				JSON.parse(json,
					// object reviver function
					function(k: String, v: *): void
					{
						switch(k)
						{
							case "url":
								_url.url = v; break;
							case "x":
								x = v; break;
							case "y":
								y = v; break;
							case "width":
								width = v; break;
							case "height":
								height = v; break;
						}
					}
				);
				loadURL(_url.url);
			}
			catch (error: Error)
			{
				// if there's a JSON parse error, dispatch an IO error
				dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, error.message));
			}
		}

		/**
		 * @param k
		 * @return JSON
		 */
		public function toJSON(k: String): *
		{
			return ({
				url: _url.url,
				x: x,
				y: y,
				width: width,
				height: height
			});
		}
	}
}