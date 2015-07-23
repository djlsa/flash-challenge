package com.djlsa.basic3d 
{
	import com.djlsa.basic3d.geometry.Object3D;
	import flash.display3D.Context3D;
	/**
	 * @author David Salsinha
	 */
	public class Renderer 
	{
		// Display list
		public var objects: Vector.<Object3D> = new Vector.<Object3D>();

		/**
		 * Creates vertex and index buffers
		 * @param context3D
		 */
		public function initObjects(context3D: Context3D): void
		{
			for each(var object: Object3D in objects)
			{
				object.initGeometry(context3D);
				object.initShader(context3D);
				object.initTexture(context3D);
			}
		}

		/**
		 * Renders the display list
		 * @param context3D
		 */
		public function render(context3D: Context3D): void
		{
			context3D.clear(0, 1, 0);

			for each(var object: Object3D in objects)
			{
				object.render(context3D);
			}

			context3D.present();
		}
	}

}