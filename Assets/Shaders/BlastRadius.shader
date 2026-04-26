Shader "Unlit/BlastRadius"
{
    Properties
    {
        _TimeScale("Speed", Float) = 1.0
        _Opacity("Opacity", Range(0.3, 0.8)) = 0.8
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha   // ← enables alpha transparency
            ZWrite Off                         // ← prevents z-buffer fighting

            GLSLPROGRAM

            #ifdef VERTEX
            
            varying vec3 localSpacePosition;

            void main()
            {
                localSpacePosition = gl_Vertex.xyz;
                gl_Position = gl_ModelViewProjectionMatrix * vec4(localSpacePosition, 1.0);
            }
            
            #endif 

            #ifdef FRAGMENT

            uniform vec4 _Time;
            uniform float _TimeScale;
            uniform float _Opacity;

            varying vec3 localSpacePosition;
            
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
                float function = remap(sin(t), -1.0, 1.0, 0.3, 0.8);

                vec3 outputColor = vec3(1,0,0);

                gl_FragColor = vec4(outputColor, _Opacity * function);
            }

            #endif

            ENDGLSL
        }
    }
}
