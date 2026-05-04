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
                // front (z = 0.75)
                vec3(0.0, 0.0, 0.75),   // 0  base center
                vec3(0.2, 0.0, 0.75),   // 1  base edge
                vec3(0.25, 0.2, 0.75),  // 2
                vec3(0.15, 0.4, 0.75),  // 3
                vec3(0.18, 0.8, 0.75),  // 4
                vec3(0.1, 1.2, 0.75),   // 5
                vec3(0.12, 1.6, 0.75),  // 6
                vec3(0.3, 2.0, 0.75),   // 7  widest part
                vec3(0.25, 2.5, 0.75),  // 8
                vec3(0.1, 3.0, 0.75),   // 9
                vec3(0.05, 3.5, 0.75),  // 10
                vec3(0.08, 4.0, 0.75),  // 11
                vec3(0.2, 4.5, 0.75),   // 12
                vec3(0.0, 5.0, 0.75),   // 13 top

                // mirrored side (left)
                vec3(-0.2, 0.0, 0.75),  // 14
                vec3(-0.25, 0.2, 0.75), // 15
                vec3(-0.15, 0.4, 0.75), // 16
                vec3(-0.18, 0.8, 0.75), // 17
                vec3(-0.1, 1.2, 0.75),  // 18
                vec3(-0.12, 1.6, 0.75), // 19
                vec3(-0.3, 2.0, 0.75),  // 20
                vec3(-0.25, 2.5, 0.75), // 21
                vec3(-0.1, 3.0, 0.75),  // 22
                vec3(-0.05, 3.5, 0.75), // 23
                vec3(-0.08, 4.0, 0.75), // 24
                vec3(-0.2, 4.5, 0.75),  // 25

                // back (z = 1.0)
                vec3(0.0, 0.0, 1.0),    // 26
                vec3(0.2, 0.0, 1.0),    // 27
                vec3(0.25, 0.2, 1.0),   // 28
                vec3(0.15, 0.4, 1.0),   // 29
                vec3(0.18, 0.8, 1.0),   // 30
                vec3(0.1, 1.2, 1.0),    // 31
                vec3(0.12, 1.6, 1.0),   // 32
                vec3(0.3, 2.0, 1.0),    // 33
                vec3(0.25, 2.5, 1.0),   // 34
                vec3(0.1, 3.0, 1.0),    // 35
                vec3(0.05, 3.5, 1.0),   // 36
                vec3(0.08, 4.0, 1.0),   // 37
                vec3(0.2, 4.5, 1.0),    // 38
                vec3(0.0, 5.0, 1.0),    // 39

                vec3(-0.2, 0.0, 1.0),   // 40
                vec3(-0.25, 0.2, 1.0),  // 41
                vec3(-0.15, 0.4, 1.0),  // 42
                vec3(-0.18, 0.8, 1.0),  // 43
                vec3(-0.1, 1.2, 1.0),   // 44
                vec3(-0.12, 1.6, 1.0),  // 45
                vec3(-0.3, 2.0, 1.0),   // 46
                vec3(-0.25, 2.5, 1.0),  // 47
                vec3(-0.1, 3.0, 1.0),   // 48
                vec3(-0.05, 3.5, 1.0),  // 49
                vec3(-0.08, 4.0, 1.0),  // 50
                vec3(-0.2, 4.5, 1.0)    // 51
                );

                int edges[] = int[](
                    // front right side
                    0,1, 1,2, 2,3, 3,4, 4,5, 5,6, 6,7, 7,8, 8,9, 9,10, 10,11, 11,12, 12,13,

                    // front left side
                    0,14, 14,15, 15,16, 16,17, 17,18, 18,19, 19,20, 20,21, 21,22, 22,23, 23,24, 24,25, 25,13,

                    // back right
                    26,27, 27,28, 28,29, 29,30, 30,31, 31,32, 32,33, 33,34, 34,35, 35,36, 36,37, 37,38, 38,39,

                    // back left
                    26,40, 40,41, 41,42, 42,43, 43,44, 44,45, 45,46, 46,47, 47,48, 48,49, 49,50, 50,51, 51,39,

                    // connect front to back
                    0,26, 1,27, 2,28, 3,29, 4,30, 5,31, 6,32,
                    7,33, 8,34, 9,35, 10,36, 11,37, 12,38, 13,39,

                    14,40, 15,41, 16,42, 17,43, 18,44, 19,45,
                    20,46, 21,47, 22,48, 23,49, 24,50, 25,51
                );

                // NEW: pre-project all points
                vec2 projected[52];
                const int size = array.length();

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