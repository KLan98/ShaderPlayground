Shader "Unlit/VaryingIndeptCube"
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

            #define PI 3.14159265359

            varying vec3 outputColor;
            varying vec3 localSpacePosition;
            varying vec2 uv;

            float InverseLerp(float currentValue, float minValue, float maxValue)
            {
                return (currentValue - minValue) / (maxValue - minValue);
            }

            float Remap(float currentValue, float inMin, float inMax, float outMin, float outMax)
            {
                float t = InverseLerp(currentValue, inMin, inMax);
                return mix(outMin, outMax, t);
            }

            // ease in function
            float EaseInSine(float x){
                return 1 - cos((x * PI) / 2);
            }

            void main()
            {
                uv = gl_MultiTexCoord0.xy;

                localSpacePosition = gl_Vertex.xyz;
                gl_Position = gl_ModelViewProjectionMatrix * vec4(localSpacePosition, 1.0);

                vec3 green = vec3(0.0, 1.0, 0.0);
                vec3 blue = vec3(0.0, 0.0, 1.0);

                // this will produce an blue first then green result
                // outputColor = mix(green, blue, uv.x);

                // remap the x component of local space pos of object from (-0.5, 0.5) to (0.0, 1.0)
                float t = Remap(localSpacePosition.x, -0.5, 0.5, 0.0, 1.0);

                // outputColor = vec3(0.0, 1.0 - EaseInSine(t), EaseInSine(t))
                // outputColor = interpolated color value of the vertex shader
                outputColor = vec3(mix(green, blue, EaseInSine(t)));
            }

            #endif

            #ifdef FRAGMENT
            
            #define PI 3.14159265359

            varying vec3 outputColor;
            varying vec3 localSpacePosition;
            varying vec2 uv;
            
            float InverseLerp(float currentValue, float minValue, float maxValue)
            {
                return (currentValue - minValue) / (maxValue - minValue);
            }

            float Remap(float currentValue, float inMin, float inMax, float outMin, float outMax)
            {
                float t = InverseLerp(currentValue, inMin, inMax);
                return mix(outMin, outMax, t);
            }

            // ease in function
            float EaseInSine(float x){
                return 1 - cos((x * PI) / 2);
            }

            void main()
            {
                vec3 color = outputColor;
                vec3 green = vec3(0.0, 1.0, 0.0);
                vec3 blue = vec3(0.0, 0.0, 1.0);
                float thickness = 0.005;

                // remap the z component of local space pos of object
                float t = Remap(localSpacePosition.z, -0.5, 0.5, 0.0, 1.0);

                // distance to the separationLine
                float distance = abs(t - 0.5);
                float separationLine = smoothstep(0.0, thickness, distance);

                if (t > 0.5)
                {
                    // graph + fragment color
                    float function = EaseInSine(Remap(localSpacePosition.x, -0.5, 0.5, 0.0, 1.0));
                    color = mix(green, blue, function);

                    float localT = Remap(t, 0.5, 1.0, 0.0, 1.0);
                    float distanceToNonLinearFunc = abs(localT - function);
                    float nonLinearGraph = smoothstep(0.0, thickness, distanceToNonLinearFunc);
                    color = mix(vec3(1), color, nonLinearGraph);
                }

                else
                {
                    // graph
                    float interpolatedBlueChannel = outputColor.b;           
                    float yAxis = Remap(t, 0.0, 0.5, 0.0, 1.0);
                    float distanceToVaryingCurve = abs(yAxis - interpolatedBlueChannel);
                    float varyingCurveMask = smoothstep(0.0, thickness, distanceToVaryingCurve);
                    color = mix(vec3(1), color, varyingCurveMask);
                }

                color = mix(vec3(1), color, separationLine);
                    
                gl_FragColor = vec4(color, 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}