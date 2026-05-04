Shader "Unlit/VertexTransformation"
{
    Properties
    {
        _TimeScale("Speed", Float) = 1.0
    }
    SubShader
    {
        Pass
        {
            GLSLPROGRAM

            #ifdef VERTEX

            uniform vec4 _Time;
            uniform float _TimeScale;

            mat3 RotateY(float radians)
            {
                float c = cos(radians);
                float s = sin(radians);

                return mat3(c, 0.0, s,
                    0.0, 1.0, 0.0,
                    -s, 0.0, c
                );
            }
            
            void main()
            {
                vec4 localSpacePosition = gl_Vertex;

                float t = _Time.y * _TimeScale;

                localSpacePosition.xyz = RotateY(t) * localSpacePosition.xyz;
                // localSpacePosition.x += sin(t); 

                // invalid since we need to manually transform the localSpacePosition into clip space
                // gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
               
                gl_Position = gl_ModelViewProjectionMatrix * localSpacePosition;
            }

            #endif

            #ifdef FRAGMENT

            void main()
            {
                vec3 outputColor = vec3(0);
                gl_FragColor = vec4(outputColor, 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}