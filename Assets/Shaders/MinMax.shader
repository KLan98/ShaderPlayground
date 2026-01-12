Shader "Unlit/MinMax"
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
                float thickness = 0.005;
                float edge0 = 0.0;
                float middle = 0.5;
                float alpha = 1.0;
                float d1 = abs(vUvs.y - middle);
                float line = smoothstep(edge0, thickness, d1);

                vec3 red = vec3(1,0,0);
                vec3 white = vec3(1,1,1);
                vec3 blue = vec3(0,0,1);
                vec3 yellow = vec3(1,1,0);
                vec3 green = vec3(0,1,0);
                vec3 outputColor = vec3(0.0);

                // needed for pixel color calculation
                float linearValue = vUvs.x;
                float maxValue = max(linearValue, 0.5); 

                // needed for the graph
                float graphFunction = mix(0.5, 1, maxValue);
                float distance = abs(vUvs.y - graphFunction);
                float linearLine = smoothstep(0, thickness, distance);

                float val2 = vUvs.x;
                float minValue = min(val2, 0.8);

                float func2 = mix(0, 0.5, minValue);
                float dis2 = abs(vUvs.y - func2);
                float line2 = smoothstep(0, thickness, dis2);
                
                // UVs coord
                float axisThickness = 0.03;
                float uAxis = smoothstep(0.0, axisThickness, abs(vUvs.x - 0.0));
                float vAxis = smoothstep(0.0, axisThickness, abs(vUvs.y - 0.0));

                if (vUvs.y >= middle)
                {
                    outputColor = mix(blue, red, maxValue);
                }

                else
                {
                    outputColor = mix(green, yellow, minValue);
                }

                outputColor = mix(red, outputColor, uAxis);
                outputColor = mix(blue, outputColor, vAxis);
                outputColor = mix(white, outputColor, line);
                outputColor = mix(white, outputColor, linearLine);
                outputColor = mix(white, outputColor, line2);
                gl_FragColor = vec4(outputColor, alpha);
            }

            #endif

            ENDGLSL
        }
    }
}
