Shader "Unlit/CRT"
{
    Properties
    {
        _TimeScale ("Speed", Float) = 1.0
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
            uniform float _TimeScale;
            uniform vec4 _Time;

            float inverseLerp(float value, float min, float max)
            {
                return (value - min)/(max-min);
            }

            float remap(float value, float inMin, float inMax, float outMin, float outMax)
            {
                float t = inverseLerp(value, inMin, inMax);
                return mix(outMin, outMax, t);
            }

            void main()
            {
                float t = _Time.y * _TimeScale;
                
                float v = remap(sin(200 * vUvs.y+t*10), -1.0, 1.0, 0.9, 1.0);
                float v2 = remap(sin(40 * vUvs.y-t*2), -1.0, 1.0, 0.9, 1.0);
                
                vec3 color = vec3(v * v2);

                gl_FragColor = vec4(color, 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}
