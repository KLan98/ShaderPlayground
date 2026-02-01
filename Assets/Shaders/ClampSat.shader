Shader "Unlit/ClampSat"
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

            varying vec2 vUvs;

            void main()
            {
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
                vUvs = gl_MultiTexCoord0.xy;
            }

            #endif

            #ifdef FRAGMENT
            
            varying vec2 vUvs;

            void main()
            {
                float middle = 0.5;
                float thickness = 0.005;
                float edge0 = 0;
                float alpha = 1.0;
                float maxVal = 0.75;
                float minVal = 0.3;

                vec3 white = vec3(1,1,1);
                vec3 red = vec3(1,0,0);
                vec3 blue = vec3(0,0,1);
                vec3 green = vec3(0,1,0);
                vec3 outputColor = vec3(0);

                float distance = abs(vUvs.y - middle);
                float separationLine = smoothstep(edge0, thickness, distance);

                // color calculation
                float linearValue = vUvs.x;
                float clampedValue = clamp(linearValue, minVal, maxVal);

                // graph
                float func = mix(0.5, 1, clampedValue);
                float d2 = abs(vUvs.y - func);
                float linearLine = smoothstep(edge0, thickness, d2);

                // color calculation
                float nonLinVal = smoothstep(-1, 1, vUvs.x);
                float satValue = clamp(nonLinVal, 0, 1);

                // graph
                float func2 = mix(0, 0.5, satValue);
                float d3 = abs(vUvs.y - func2);
                float nonLinLine = smoothstep(edge0, thickness, d3);

                if (vUvs.y >= middle)
                {
                    outputColor = mix(red, green, clampedValue);
                }
                
                else
                {
                    outputColor = mix(red, blue, satValue);
                }
                
                outputColor = mix(white, outputColor, separationLine);
                outputColor = mix(white, outputColor, linearLine);
                outputColor = mix(white, outputColor, nonLinLine);
                gl_FragColor = vec4(outputColor, alpha);  
            }

            #endif

            ENDGLSL
        }
    }
}
