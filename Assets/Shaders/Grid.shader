Shader "Unlit/Grid"
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
                int dimension = 1; // 10x10
                vec3 cells = fract(vec3(vUvs, 1.0) * dimension);
                // cells = abs(cells - 0.5);

                float distance = 1 - max(cells.x, cells.y);
                float cellLine = smoothstep(0, 0.1, distance);
                
                gl_FragColor = vec4(vec3(cellLine), 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}
