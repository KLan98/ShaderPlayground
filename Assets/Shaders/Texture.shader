Shader "Unlit/Texture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white"{}
        _Red ("Red tint", Color) = (1,0,0,1)
        _Blue ("Blue tint", Color) = (0,0,1.0,1)
        _FlipY ("Flip Y", int) = 0
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

            uniform sampler2D _MainTex;
            uniform vec4 _Red;
            uniform vec4 _Blue;
            uniform int _FlipY;

            void main()
            {
                // flipped the y axis
                if (_FlipY == 1)
                {
                    vec2 flippedUvs = vec2(vUvs.x, 1-vUvs.y);
                    vec4 diffuseSample = texture2D(_MainTex, flippedUvs); 
                    gl_FragColor = diffuseSample * _Blue; // vec4 x vec4
                }

                else
                {
                    vec4 diffuseSample = texture2D(_MainTex, vUvs); 
                    gl_FragColor = diffuseSample * _Red; // vec4 x vec4
                }
            }
            
            #endif

            ENDGLSL
        }
    }
}
