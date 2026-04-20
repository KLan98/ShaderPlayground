Shader "Unlit/VertexTransform_2"
{
    Properties
    {
        _TimeScale("Speed", Float) = 2.0
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

                return mat3(
                    c, 0.0, s,
                    0.0, 1.0, 0.0,
                    -s, 0.0, c
                );
            }

            void main()
            {
                float t = _Time.y * _TimeScale;

                vec3 localSpacePosition = gl_Vertex.xyz;

                localSpacePosition.x += 2;
                localSpacePosition = RotateY(t) * localSpacePosition;

                gl_Position = gl_ModelViewProjectionMatrix * vec4(localSpacePosition, 1.0); 
            }

            #endif

            #ifdef FRAGMENT

            void main()
            {
                vec3 outputColor = vec3(1.0, 0.0, 0.0);
                gl_FragColor = vec4(outputColor, 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}
