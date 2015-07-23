package com.djlsa.basic3d {
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	/**
	 * @author David Salsinha
	 */
	public class Shader 
	{
		private static const ASSEMBLER: AGALMiniAssembler = new AGALMiniAssembler();

		// simple shader program
		public static const PROGRAM_SIMPLE: Shader =
			new Shader(
				"m44 op, va0, vc0\nmov v0, va1\n",
				"tex oc, v0, fs0 <2d,linear,mipnone>"
			)
		;

		// compiled shaders
		private var
			_vertexShaderAGAL: ByteArray,
			_fragmentShaderAGAL: ByteArray
		;

		// this shader's program
		public var program: Program3D;

		public function Shader(vertexShader: String, fragmentShader: String)
		{
			// compile shaders
			_vertexShaderAGAL = ASSEMBLER.assemble(Context3DProgramType.VERTEX, vertexShader);
			_fragmentShaderAGAL = ASSEMBLER.assemble(Context3DProgramType.FRAGMENT, fragmentShader);
		}

		/**
		 * Creates program from Context3D
		 * @param context3D
		 */
		public function initProgram(context3D: Context3D): void
		{
			program = context3D.createProgram();
			program.upload(_vertexShaderAGAL, _fragmentShaderAGAL);
		}
	}

}