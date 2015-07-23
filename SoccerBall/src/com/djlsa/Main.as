package com.djlsa
{
	import com.djlsa.basic3d.geometry.Sphere3D;
	import com.djlsa.basic3d.Renderer;
	import com.djlsa.basic3d.Shader;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author David Salsinha
	 */
	public class Main extends Sprite 
	{
		[Embed(source="Football.png")]
		private var _soccerBallImage: Class;

		// ball rotation speed and increment step
		private const
			SPEED_MAX: Number = 1,
			SPEED_INCREMENT: Number = 0.01
		;

		private var
			_context3D: Context3D,
			_renderer: Renderer = new Renderer(),
			_soccerBall: Sphere3D = new Sphere3D(),
			_dragging: Boolean = false,
			_clickPosition: Object,
			_dragPosition: Object,
			_speed: Number = 0
		;

		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point

			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;

			// sets soccer ball texture
			_soccerBall.setTexture((new _soccerBallImage() as Bitmap).bitmapData);
			// adds to 3D renderer's display list
			_renderer.objects.push(_soccerBall);

			var stage3D:Stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			stage3D.requestContext3D(Context3DRenderMode.AUTO);

			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandler);
		}

		private function onContextCreated(event: Event): void
		{
			var stage3D:Stage3D = stage.stage3Ds[0];
			stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			_context3D = stage3D.context3D;
			_context3D.configureBackBuffer(
				stage.stageWidth,
				stage.stageHeight,
				0,
				true
			);

			_renderer.initObjects(_context3D);

			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event: Event): void
		{
			// check if dragging mouse, increase rotation speed until max
			if (_dragging && _speed < SPEED_MAX)
				_speed += SPEED_INCREMENT * 10;

			// check if rotating and there's a drag position defined
			if (_speed > 0 && _dragPosition) {
				// apply rotation
				_soccerBall.transform.prependRotation(10 * _speed,
					new Vector3D(
						_dragPosition.y,
						_dragPosition.x,
						-_dragPosition.x
					)
				);
				// start decreasing speed
				_speed -= SPEED_INCREMENT;
			}

			// render the display list
			_renderer.render(_context3D);
		}
		
		private function mouseHandler(event: MouseEvent): void
		{
			switch(event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					// get starting click position
					_clickPosition = { x: event.localX, y: event.localY };
					_dragging = true;
					break;
				case MouseEvent.MOUSE_UP:
					_dragging = false;
					break;
				case MouseEvent.MOUSE_MOVE:
					if (_dragging)
						// get current mouse drag position
						_dragPosition = { x: _clickPosition.x - event.localX, y: _clickPosition.y - event.localY }
			}
		}
	}
}