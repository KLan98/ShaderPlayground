Shader "Unlit/Uniform"
{
	Properties {
		_Red ("Red", Color) = (1,0,0,1)
		_Green ("Green", Color) = (0,1,0,1)
		_Blue ("Blue", Color) = (0,0,1,1)
		_Yellow ("Yellow", Color) = (1,1,0,1)
	}

	SubShader
	{
		Pass
		{
			GLSLPROGRAM
			
			#ifdef VERTEX
			
			varying vec2 vUvs;

			void main()
			{
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

				vUvs = gl_MultiTexCoord0.xy;
			}

			#endif 

			#ifdef FRAGMENT

			varying vec2 vUvs;
			uniform vec4 _Red;
			uniform vec4 _Blue;
			uniform vec4 _Yellow;
			uniform vec4 _Green;

			void main()
			{
				vec4 redblue = mix(_Red, _Blue, vUvs.y);
				vec4 yellowgreen = mix(_Yellow, _Green, vUvs.y);
				gl_FragColor = mix(redblue, yellowgreen, 1 -vUvs.x);
			}

			#endif
			ENDGLSL
		}
	}
}
