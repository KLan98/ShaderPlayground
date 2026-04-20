Shader "Unlit/Starfield"
{
    Properties {}
    SubShader
    {
        Pass
        {
            GLSLPROGRAM

            #ifdef VERTEX

            varying vec2 uv;

            void main()
            {
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex; 
                uv = gl_MultiTexCoord0.xy;
            }

            #endif

            #ifdef FRAGMENT

            varying vec2 uv;

            void main()
            {
                // 1. Subtract 0.5 to center the origin
                vec2 centeredUV = uv - 0.5;

                vec3 color = vec3(0);

                // Draw a circle: all pixels within radius 0.2 from center
                float radius = 0.2;
                float dist = length(centeredUV);
                
                float m = smoothstep(0.1, 0.9, dist);

                color += m;

                gl_FragColor = vec4(color, 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}