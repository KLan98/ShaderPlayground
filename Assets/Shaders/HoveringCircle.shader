Shader "Unlit/HoveringCircle"
{
    Properties
    {
        _TimeScale ("Speed", Float) = 1.0
    }
    SubShader
    {
        LOD 100

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
            uniform vec4 _Time;
            uniform float _TimeScale;

            vec2 REPEAT(vec2 shape, int dimension)
            {
                return fract(shape * dimension);
            }

            vec2 HOVER(vec2 position, float magnitude, float time)
            {
                position.y += magnitude * sin(time);
                return position;
            }

            void main()
            {
                float t = _TimeScale * _Time.y;
                vec2 cell = REPEAT(vUVs, 1);

                cell = HOVER(cell, 0.5, t); 

                float eucliDistance = sqrt(pow(cell.x - 0.5, 2) + pow(cell.y - 0.5, 2));

                float distanceToCell = 1 - 8 * eucliDistance;

                float outputColor = smoothstep(0, 0.01, distanceToCell);

                gl_FragColor = vec4(vec3(outputColor), 1.0);
            }

            #endif
            
            ENDGLSL
        }
    }
}
