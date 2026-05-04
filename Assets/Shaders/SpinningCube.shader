Shader "Unlit/SpinningCube"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TimeScale("Speed", Float) = 1.0
        _Scale("Scale", Float) = 1.0
    }
    SubShader
    {
        Pass
        {
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

            varying vec3 localSpacePosition;
            float dz;
            uniform float _TimeScale;
            uniform vec4 unity_DeltaTime;
            uniform vec4 _Time;
            uniform float _Scale;
     
            float INVERSE_LERP(float current, float min, float max)
            {
                return (current - min) / (max - min);
            }

            float REMAP(float current, float inMin, float inMax, float outMin, float outMax)
            {
                float value = INVERSE_LERP(current, inMin, inMax);
                return mix(outMin, outMax, value);
            }

            vec2 SCREEN(vec2 p)
            {
                float minCoord = -5.0;
                float maxCoord = 5.0;

                float newMinCoord = -1.0;
                float newMaxCoord = 1.0;

                return vec2(REMAP(p.x, minCoord, maxCoord, newMinCoord, newMaxCoord), REMAP(p.y, minCoord, maxCoord, newMinCoord, newMaxCoord));
            }

            void PLACEPOINT(vec2 screen, vec2 p, float pointSize, inout vec3 outputColor)
            {
                vec3 pointColor = vec3(1.0, 0.0, 0.0);

                float d = max(abs(screen.x - p.x), abs(screen.y - p.y));
                
                float renderMask = 1 - smoothstep(0.05, pointSize, d);

                outputColor = mix(outputColor, pointColor, renderMask);
            }

            // 3d to 2d screen projection
            vec2 PROJECTION(vec3 p)
            {
                return vec2(p.x/p.z, p.y/p.z);
            }

            mat3 ROTATEY(float angle)
            {
                float c = cos(angle);
                float s = sin(angle);

                return mat3(c, 0.0, s,
                    0.0, 1.0, 0.0,
                    -s, 0.0, c
                );
            }

            vec3 ROTATE_AROUND_CENTER_Y(vec3 p, float angle)
            {
                // approximate center of your shape (midpoint of z: 0.75 → 1.0)
                // Translates the point so the object center is at (0,0,0)
                vec3 center = vec3(0.0, 0.0, 0.875);

                // move to origin
                vec3 local = p - center;

                // rotate
                local = ROTATEY(angle) * local;

                // move back
                return local + center;
            }

            // Distance from point 'p' to line segment 'a'-'b'
            float LINE_DIST(vec2 p, vec2 a, vec2 b)
            {
                vec2 ab = b - a;
                vec2 ap = p - a;
                float t = clamp(dot(ap, ab) / dot(ab, ab), 0.0, 1.0);
                return length(ap - ab * t);
            }

            void DRAWLINE(vec2 screen, vec2 a, vec2 b, float thickness, inout vec3 color)
            {
                float d = LINE_DIST(screen, a, b);
                float mask = 1.0 - smoothstep(0.0, thickness, d);
                color = mix(color, vec3(1.0, 0.0, 0.0), mask);
            }

            vec3 SCALE(vec3 p, float s)
            {
                return p * s;
            }

            void main()
            {
                float dz = _Time.y * _TimeScale;
                vec3 outputColor = vec3(0.0);
                float pointSize = 0.05;

                vec2 myScreen = SCREEN(vec2(localSpacePosition.x, localSpacePosition.z));
                vec3 array[] = vec3[](
                vec3( 0.0,   0.155,  0.75),
                vec3( 0.04,  0.24,   0.75),
                vec3( 0.208, 0.285,  0.75),
                vec3( 0.32,  0.135,  0.75),
                vec3( 0.208, -0.055, 0.75),
                vec3( 0.04,  -0.21,  0.75),
                vec3( 0.0,   -0.285, 0.75),
                vec3(-0.04,  -0.21,  0.75),
                vec3(-0.208, -0.055, 0.75),
                vec3(-0.32,  0.135,  0.75),
                vec3(-0.208, 0.285,  0.75),
                vec3(-0.04,  0.24,   0.75),
                vec3( 0.0,   0.155,  1.0),
                vec3( 0.04,  0.24,   1.0),
                vec3( 0.208, 0.285,  1.0),
                vec3( 0.32,  0.135,  1.0),
                vec3( 0.208, -0.055, 1.0),
                vec3( 0.04,  -0.21,  1.0),
                vec3( 0.0,   -0.285, 1.0),
                vec3(-0.04,  -0.21,  1.0),
                vec3(-0.208, -0.055, 1.0),
                vec3(-0.32,  0.135,  1.0),
                vec3(-0.208, 0.285,  1.0),
                vec3(-0.04,  0.24,   1.0)
                );

                int edges[] = int[](
                0,1, 1,2, 2,3, 3,4, 4,5, 5,6, 6,7, 7,8, 8,9, 9,10, 10,11, 11,0,
                12,13, 13,14, 14,15, 15,16, 16,17, 17,18, 18,19, 19,20, 20,21, 21,22, 22,23, 23,12,
                0,12, 1,13, 2,14, 3,15, 4,16, 5,17, 6,18, 7,19, 8,20, 9,21, 10,22, 11,23
                );
                
                // NEW: pre-project all points
                const int size = array.length();
                vec2 projected[size];

                for (int i = 0; i < size; i++)
                {
                    // projected[i] = PROJECTION(array[i] * ROTATEY(dz));
                    projected[i] = PROJECTION(ROTATE_AROUND_CENTER_Y(SCALE(array[i], _Scale), dz));
                }

                const int edgeCount = edges.length() / 2;
                for (int i = 0; i < edgeCount; i++)
                {
                    DRAWLINE(myScreen, projected[edges[i*2]], projected[edges[i*2+1]], 0.005, outputColor);
                }

                // for (int i = 0; i < size; i++)
                // {
                //     PLACEPOINT(myScreen, projected[i], pointSize, outputColor);
                // }

                // for (int i = 0; i < size; i++)
                // {
                //     vec3 point = array[i];
                //     PLACEPOINT(myScreen, PROJECTION(ROTATEY(dz) * point), pointSize, outputColor);
                // }

                gl_FragColor = vec4(outputColor, 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}