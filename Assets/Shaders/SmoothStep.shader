Shader "Unlit/SmoothStep"
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

            varying vec2 vUvs;

            void main()
            {
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
                vUvs = gl_MultiTexCoord0.xy;
            }

            #endif

            #ifdef FRAGMENT

            varying vec2 vUvs;

            void main()
            {                
                // vec3 color = vec3(smoothstep(0.0, 10, sin(vUvs.x)));
                float threshold = 0.5;

                float line = smoothstep(0, 1, abs(vUvs.x - threshold));

                // vec3 color = vec3(line);

                gl_FragColor = vec4(line, 0, 0, 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}
