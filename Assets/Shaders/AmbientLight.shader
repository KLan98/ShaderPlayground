Shader "Unlit/AmbientLight"
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

            varying vec2 uv;

            void main()
            {
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
                uv = gl_MultiTexCoord0.xy;
            }

            #endif

            #ifdef FRAGMENT

            void main()
            {
                vec3 baseColor = vec3(0.5);
                vec3 lighting = vec3(1.0);

                // AmbientLight
                vec3 ambient = vec3(0.3);
                lighting = ambient;

                vec3 outputColor = baseColor * lighting;

                gl_FragColor = vec4(outputColor, 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}
