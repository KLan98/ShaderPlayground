Shader "Unlit/PseudoRandomNoise"
{
    Properties
    {
    }
    SubShader
    {
        Pass
        {
            GLSLPROGRAM

            #ifdef VERTEX

            varying vec2 UV;
            varying vec3 localSpacePosition;

            void main()
            {
                localSpacePosition = gl_Vertex.xyz;
                gl_Position = gl_ModelViewProjectionMatrix * vec4(localSpacePosition, 1.0);
                UV = gl_MultiTexCoord0.xy;
            }

            #endif

            #ifdef FRAGMENT

            // formula for pseudo random noise
            float RAND(vec2 st)
            {
                return fract(sin(dot(st.xy, vec2(12.34, 56.78))) * 43758.5453123);
            }

            varying vec2 UV;
            varying vec3 localSpacePosition;

            void main()
            {
                vec3 color = vec3(RAND(localSpacePosition.xz));
                gl_FragColor = vec4(color, 1.0);
            }

            #endif

            ENDGLSL

        }
    }
}
