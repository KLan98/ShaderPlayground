Shader "Unlit/GridUV"
{
    Properties
    {
        // _Distance
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
                vec2 cell = REPEAT(vUvs, 10);

                float chebyDistance = max(abs(cell.x - 0.5), abs(cell.y - 0.5)); 

                float manDistance = abs(cell.x - 0.5) + abs(cell.y - 0.5);

                float eucliDistance = sqrt(pow(cell.x - 0.5, 2) + pow(cell.y - 0.5, 2));

                // float distanceToCell = 1 - 2 * chebyDistance;

                // float distanceToCell = 1 - 2 * manDistance;

                float distanceToCell = 1 - 2 * eucliDistance;

                float outputColor = smoothstep(0, 0.1, distanceToCell);

                gl_FragColor = vec4(vec3(outputColor), 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}
