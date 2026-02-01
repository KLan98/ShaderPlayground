Shader "Unlit/GridUV"
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

            vec2 REPEAT(vec2 shape, int dimension)
            {
                return fract(shape * dimension);
            }

            void main()
            {
                vec3 cell = vec3(REPEAT(vUvs, 2), 0.0); // repeat uv with dimension = x

                cell = abs(cell - 0.5); // distance between the cell and 0.5

                float chebyDistance = max(cell.x, cell.y); // Chebyshew distance
                float distance = 1- 10 * chebyDistance;

                // float distance = 1 - 2 * chebyDistance;

                float outputColor = smoothstep(0, 0.1, distance);

                gl_FragColor = vec4(vec3(outputColor), 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}
