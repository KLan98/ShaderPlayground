Shader "Unlit/RadialGradient"
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

            varying vec2 vUVs;

            void main()
            {
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
                vUVs = gl_MultiTexCoord0.xy;
            }

            #endif

            #ifdef FRAGMENT

            varying vec2 vUVs;
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
                vec3 yellow = vec3(1.0, 1.0, 0.1);
                vec3 turqoise = vec3(0.1, 1.0, 1.0);
                vec2 center = vec2(0.5);
                float t = _Time.y * _TimeScale;
                float v = remap(sin(200 * vUVs.y+t*10), -1.0, 1.0, 0.9, 1.0);
                float v2 = remap(sin(40 * vUVs.y-t*2), -1.0, 1.0, 0.9, 1.0);
                vec3 CRT = vec3(v * v2);

                float eucliDistance = distance(vUVs, center);

                float distanceToRender = 1 - 2.7 * eucliDistance;

                float renderGradient = smoothstep(0, 0.5, distanceToRender);

                vec3 outputColor = mix(yellow, turqoise, renderGradient);

                gl_FragColor = vec4(outputColor*CRT, 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}
