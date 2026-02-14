Shader "Unlit/Sine"
{
    Properties
    {
        _TimeScale ("Speed", Float) = 1.0 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
            uniform float _TimeScale;
            uniform vec4 _Time;

            float inverseLerp(float currentValue, float min, float max)
            {
                return (currentValue - min)/(max - min);
            }

            float remap(float currentValue, float inMin, float inMax, float outMin, float outMax)
            {
                float t = inverseLerp(currentValue, inMin, inMax);
                return mix(outMin, outMax, t);
            }

            void main()
            {
                float t = _Time.y * _TimeScale;

                // method 1
                // float v = 0.5 + 0.5 * sin(t); convert from -1, 1 to 0, 1 

                // method 2 use remap
                float v = remap(sin(t), -1.0, 1.0, 0.0, 1.0);

                vec3 color = vec3(v);

                gl_FragColor = vec4(color, 1.0);
            }

            #endif 

            ENDGLSL
        }
    }
}
