package com.djlsa.basic3d.geometry {
	import com.djlsa.basic3d.Shader;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;
	/**
	 * @author David Salsinha
	 */
	public class Object3D
	{
		// vector with geometry and texture coordinates, used to create vertex and index buffers
		protected var
			vertices:Vector.<Number>,
			textureCoordinates:Vector.<Number>,
			triangles:Vector.<uint>
		;

		private var
			// geometry and texture coordinates buffers
			_verticesVertexBuffer: VertexBuffer3D,
			_textureCoordinatesVertexBuffer: VertexBuffer3D,
			_trianglesIndexBuffer: IndexBuffer3D,

			// shader program
			_shader: Shader = Shader.PROGRAM_SIMPLE,

			// texture
			_textureBitmap: BitmapData,
			_texture: Texture
		;

		// object's position and rotation
		public var transform :Matrix3D = new Matrix3D();

		public function Object3D()
		{
			// set transform matrix to identity matrix
			transform.identity();
		}

		/**
		 * Initializes geometry and texture coordinate buffers
		 * @param context3D
		 */
		public function initGeometry(context3D: Context3D): void
		{
			this._verticesVertexBuffer = context3D.createVertexBuffer(vertices.length/3, 3);
			this._verticesVertexBuffer.uploadFromVector(vertices, 0, vertices.length/3);
			this._textureCoordinatesVertexBuffer = context3D.createVertexBuffer(textureCoordinates.length/2, 2);
			this._textureCoordinatesVertexBuffer.uploadFromVector(textureCoordinates, 0, textureCoordinates.length/2);
			this._trianglesIndexBuffer = context3D.createIndexBuffer(triangles.length);
			this._trianglesIndexBuffer.uploadFromVector(triangles, 0, triangles.length);
		}

		public function setTexture(image: BitmapData): void
		{
			_textureBitmap = image;
		}

		/**
		 * Initializes the texture
		 * @param context3D
		 */
		public function initTexture(context3D: Context3D): void
		{
			_texture = context3D.createTexture(
				_textureBitmap.width,
				_textureBitmap.height,
				Context3DTextureFormat.BGRA,
				true
			);
			_texture.uploadFromBitmapData(_textureBitmap);
		}

		public function setShader(shader: Shader): void
		{
			_shader = shader;
		}

		/**
		 * Initializes the shader program
		 * @param context3D
		 */
		public function initShader(context3D: Context3D): void
		{
			_shader.initProgram(context3D);
		}

		/**
		 * Renders the object
		 * @param context3D
		 */
		public function render(context3D: Context3D): void
		{
			// sets shader program and texture
			context3D.setProgram(_shader.program);
			context3D.setTextureAt(0, _texture);
 
			// sets up vertices and texture coordinates
			context3D.setVertexBufferAt(0, _verticesVertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, _textureCoordinatesVertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
 
			// sets up shader with the object's transform matrix
			context3D.setProgramConstantsFromMatrix(
				Context3DProgramType.VERTEX,
				0,
				transform,
				false
			);

			// draws triangles
			context3D.drawTriangles(_trianglesIndexBuffer);
		}
	}

}