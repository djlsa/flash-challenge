package com.djlsa.basic3d.geometry {
	/**
	 * @author Jackson Dunstan
	 * @see http://jacksondunstan.com/articles/1904
	 */
	public class Sphere3D extends Object3D
	{
		public function Sphere3D() 
		{
			var slices: uint = 20, stacks: uint = 20;
 
			// Pre-compute many constants used in tesselation
			const stepTheta:Number = (2.0*Math.PI) / slices;
			const stepPhi:Number = Math.PI / stacks;
			const stepU:Number = 1.0 / slices;
			const stepV:Number = 1.0 / stacks;
			const verticesPerStack:uint = slices + 1;
			const numVertices:uint = verticesPerStack * (stacks+1);
 
			// Allocate the vectors of data to tesselate into
			vertices = new Vector.<Number>(numVertices*3);
			textureCoordinates = new Vector.<Number>(numVertices*2);
			triangles = new Vector.<uint>(slices*stacks*6);
 
			// Pre-compute half the sin/cos of thetas
			var halfCosThetas:Vector.<Number> = new Vector.<Number>(verticesPerStack);
			var halfSinThetas:Vector.<Number> = new Vector.<Number>(verticesPerStack);
			var curTheta:Number = 0;
			for (var slice:uint; slice < verticesPerStack; ++slice)
			{
				halfCosThetas[slice] = Math.cos(curTheta) * 0.5;
				halfSinThetas[slice] = Math.sin(curTheta) * 0.5;
				curTheta += stepTheta;
			}
 
			// Generate positions and texture coordinates
			var curV:Number = 1.0;
			var curPhi:Number = Math.PI;
			var posIndex:uint;
			var texCoordIndex:uint;
			for (var stack:uint = 0; stack < stacks+1; ++stack)
			{
				var curU:Number = 1.0;
				var curY:Number = Math.cos(curPhi) * 0.5;
				var sinCurPhi:Number = Math.sin(curPhi);
				for (slice = 0; slice < verticesPerStack; ++slice)
				{
					vertices[posIndex++] = halfCosThetas[slice]*sinCurPhi;
					vertices[posIndex++] = curY;
					vertices[posIndex++] = halfSinThetas[slice] * sinCurPhi;
 
					textureCoordinates[texCoordIndex++] = curU;
					textureCoordinates[texCoordIndex++] = curV;
					curU -= stepU;
				}
 
				curV -= stepV;
				curPhi -= stepPhi;
			}
 
			// Generate triangles
			var lastStackFirstVertexIndex:uint = 0;
			var curStackFirstVertexIndex:uint = verticesPerStack;
			var triIndex:uint;
			for (stack = 0; stack < stacks; ++stack)
			{
				for (slice = 0; slice < slices; ++slice)
				{
					// Bottom tri of the quad
					triangles[triIndex++] = lastStackFirstVertexIndex + slice + 1;
					triangles[triIndex++] = curStackFirstVertexIndex + slice;
					triangles[triIndex++] = lastStackFirstVertexIndex + slice;
 
					// Top tri of the quad
					triangles[triIndex++] = lastStackFirstVertexIndex + slice + 1;
					triangles[triIndex++] = curStackFirstVertexIndex + slice + 1;
					triangles[triIndex++] = curStackFirstVertexIndex + slice;
				}
 
				lastStackFirstVertexIndex += verticesPerStack;
				curStackFirstVertexIndex += verticesPerStack;
			}
		}
	}
}