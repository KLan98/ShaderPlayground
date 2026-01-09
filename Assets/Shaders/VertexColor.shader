Shader "GLSL/VertexColorExample"
{
    SubShader
    {
        Pass
        {
            GLSLPROGRAM

            #ifdef VERTEX
            varying vec4 vColor;

            void main()
            {
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

                // Pass vertex color to fragment shader
                vColor = gl_Color;
            }
            #endif

            #ifdef FRAGMENT
            varying vec4 vColor;

            void main()
            {
                gl_FragColor = vColor; // displays the per-vertex color
            }
            #endif

            ENDGLSL
        }
    }
}
