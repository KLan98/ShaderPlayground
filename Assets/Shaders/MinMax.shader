Shader "Unlit/MinMax"
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

            }

            #endif

            ENDGLSL
        }
    }
}
